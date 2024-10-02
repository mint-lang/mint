module Mint
  @[Flags]
  enum Check
    Environment
    Unreachable
  end

  class LSWorkspace
    delegate :artifacts, :ast, :update, :delete, :process, to: @cache

    def initialize(uri : String)
      @cache =
        if uri.starts_with?("sandbox://")
          SandboxWorkspace.new(Check::All)
        else
          FileWorkspace.new(
            include_tests: false,
            check: Check::All,
            listener: nil,
            format: false,
            watch: true,
            path: uri)
        end
    end

    def format(uri : String) : String?
      Formatter.new.format(ast) if ast = ast(uri)
    end
  end

  class Workspace2
    class Cache
      # Stores the AST (or error) of the file at the given path.
      @cache : Hash(String, Ast | Error) = {} of String => Ast | Error

      def initialize(@check : Check)
      end

      def update(contents : String, path : String)
        @cache[path] = Parser.parse?(contents, path)
      end

      def delete(path : String)
        @cache.delete(path)
      end

      def ast(path : String) : Ast | Error | Nil
        @cache[path]?
      end

      def clear
        @cache.clear
      end

      def process
        errors =
          @cache.values.select(Error)

        if error = errors.first?
          error
        else
          ast =
            @cache
              .values
              .select(Ast)
              .reduce(Ast.new) { |memo, item| memo.merge item }
              .tap do |item|
                # Only merge the core if it's not the core (if it has `Maybe`
                # defined then it's the core).
                item.merge(Core.ast) unless item.type_definitions.index(&.name.==("Maybe"))
              end
              .normalize

          TypeChecker.new(
            check_everything: @check.unreachable?,
            check_env: @check.environment?,
            ast: ast
          ).tap(&.check)
        end
      rescue error : Error
        error
      end
    end

    @result : TypeChecker | Error = Error.new(:unitialized_workspace)
    @listener : Proc(TypeChecker | Error, Nil) | Nil
    @cache : Cache

    @id = 0

    def initialize
      @cache = Workspace.new(Check::All)
    end

    def artifacts : Artifacts | Error
      case result
      in TypeChecker
        result.artifacts
      in Error
        result
      end
    end

    def ast : Ast | Error
      case result
      in TypeChecker
        result.artifacts.ast
      in Error
        result
      end
    end

    def ast(path : String) : Ast | Error | Nil
      @cache.ast(path)
    end

    def update(contents : String, path : String)
      @cache.update(contents, path)
      notify
    end

    def delete(path : String)
      @cache.delete(path)
      notify
    end

    # This is a debounced method so it type checks after
    # all changes have processed.
    def notify
      if @async
        id = @id += 1

        spawn do
          sleep 0.5.seconds
          next if id != @id
          process
          @id = 0
        end
      else
        process
      end
    end

    def process
      @result = Logger.log "Type Checking" { @cache.process }
      @listener.try(&.call(@result))
    end
  end

  class SandboxWorkspace < Workspace2
    @async = true
  end

  class FileWorkspace < Workspace2
    enum Action
      Compile
      Reset
    end

    getter? include_tests : Bool = false
    getter? format : Bool
    getter path : String

    def initialize(
      *,
      @listener : Proc(TypeChecker | Error, Nil),
      @include_tests : Bool,
      @format : Bool,
      @path : String,
      check : Check,
      watch : Bool
    )
      @cache = Cache.new(check)
      @watcher = Watcher.new(%w[])
      @async = watch

      reset(!watch)
      spawn { @watcher.watch(&->update(Array(String))) } if watch
    end

    def reset(process : Bool = true)
      @cache.clear

      @watcher.pattern = globs =
        SourceFiles.everything(
          MintJson.parse(@path),
          include_tests: @include_tests)

      update(Dir.glob(globs.select(&.ends_with?(".mint")))) if process
    end

    def update(files : Array(String))
      actions = [] of Action

      Logger.log "Parsing files" do
        files.each do |file|
          if File.extname(file) == ".mint"
            if File.exists?(file)
              contents = File.read(file)
              @cache.update(contents, file)

              if format?
                case ast = @cache.ast(file)
                when Ast
                  formatted =
                    Formatter.new.format(ast)

                  if formatted != contents
                    File.write(file, formatted)
                  end
                end
              end
            else
              @cache.delete(file)
            end

            actions << Action::Compile
          else
            # We need to do a reset because:
            # 1. packages could have changed
            # 2. source directories could have changed
            # 3. variables in the .env file cloud have changed
            case File.basename(file)
            when "mint.json", ".env"
              actions << Action::Reset
            end
          end
        end
      end

      if actions.includes?(Action::Reset)
        reset
      else
        process
      end
    end
  end
end
