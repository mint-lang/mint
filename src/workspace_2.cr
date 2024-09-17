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
    getter? format : Bool
    getter check : Check

    def initialize(
      *,
      @check : Check,
      @format : Bool,
      &@listener : TypeChecker | Error -> Nil
    )
      @workspace =
        Workspace2.new(check)

      @json =
        MintJson.current

      @globs =
        [
          ".mint/**/*.mint",
          ".mint/**/mint.json",
          "**/*.mint",
          "**/mint.json",
          ".env",
        ]

      @watcher =
        Watcher.new(@globs)

      spawn { @watcher.watch(&->update(Array(String))) }
    end

    def reset
      @workspace.clear
      update(Dir.glob(@globs.select(&.ends_with?(".mint"))))
    end

    def update(files : Array(String))
      process = true

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

                  # Since formatting a file will trigger another change we skip
                  # processing this file and don't trigger type checking.
                  process = false
                  next
                end
              end
            end

            @workspace.update(contents, file)
          else
            @workspace.delete(file)
          end
        else
          # We need to do a reset because:
          # 1. packages could have been added or removed
          # 2. source directories could have been added or removed
          case File.basename(file)
          when "mint.json"
            reset
          end
        end
      end

      @listener.call(@workspace.process) if process
    end
  end
end
