module Mint
  @[Flags]
  enum Check
    Environment
    Unreachable
  end

  class Workspace2
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

    def ast?(path : String)
      case ast = @cache[path]?
      when Ast
        ast
      end
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
            .tap(&.merge(Core.ast))
            .tap(&.normalize)

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

  class FileWorkspace
    enum Action
      Compile
      Reset
    end

    getter? include_tests : Bool = false
    getter? format : Bool
    getter path : String

    def initialize(
      *,
      @include_tests : Bool,
      @format : Bool,
      @path : String,
      check : Check,
      watch : Bool,
      &@listener : TypeChecker | Error -> Nil
    )
      @workspace = Workspace2.new(check)
      @watcher = Watcher.new(%w[])

      reset(!watch)
      spawn { @watcher.watch(&->update(Array(String))) } if watch
    end

    def reset(process : Bool = true)
      @workspace.clear

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
              contents =
                File.read(file)

              if format?
                if ast = @workspace.ast?(file)
                  formatted =
                    Formatter.new.format(ast)

                  if formatted != contents
                    File.write(file, formatted)
                  end
                end
              end

              @workspace.update(contents, file)
            else
              @workspace.delete(file)
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
        @listener.call(Logger.log "Type Checking" { @workspace.process })
      end
    end
  end
end
