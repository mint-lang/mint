module Mint
  # A workspace represents a Mint project in the file system.
  # - It provides up to date, type checked artifacts which can be used in other
  #   places (bundler, test runner, development server, etc...).
  # - It watches the appropriate files and recompiles when they change.
  # - It does a compilation on initialization, so artifacts are ready to be
  #   used.
  #
  class Workspace
    record Result, value : TypeChecker | Error, warnings : Array(Warning)

    # The current result of the program (type checker or error) and warnings.
    getter result : Result = Result.new(Error.new(:uninitialized_workspace), [] of Warning)

    # Stores the AST (or error) of the file at the given path, along with
    # any parser warnings.
    @cache = {} of String => {Ast, Array(Warning)} | Error

    # The listener to call when a new result is ready.
    @listener : Proc(Result, Nil)?

    def initialize(
      *,
      @checked_entities : Array(String) = [] of String,
      @listener : Proc(Result, Nil)?,
      @include_tests : Bool,
      dot_env : String,
      @format : Bool,
      @check : Check,
      @path : String,
    )
      @dot_env =
        File.expand_path(dot_env)

      (@watcher = Watcher.new(&->update(Array(String), Symbol)))
        .tap { reset }
        .watch
    end

    def update(contents : String, path : String) : Nil
      result, warnings = Parser.parse_with_warnings(contents, path)

      @cache[path] =
        case value = result
        in Ast
          {value, warnings}
        in Error
          value
        end
    end

    def delete(path : String) : Nil
      @cache.delete(path)
    end

    def artifacts : TypeChecker::Artifacts | Error
      map_error(result.value, &.artifacts)
    end

    def ast(path : String) : Ast | Error?
      case value = @cache[path]?
      when Tuple(Ast, Array(Warning))
        value[0]
      when Error
        value
      end
    end

    def ast : Ast | Error
      map_error(artifacts, &.ast)
    end

    def warnings(value : TypeChecker | Error) : Array(Warning)
      parser_warnings =
        @cache.values.compact_map do |item|
          case item
          when Tuple(Ast, Array(Warning))
            item[1]
          end
        end.flatten

      type_checker_warnings =
        case value
        when TypeChecker
          value.warnings
        else
          [] of Warning
        end

      parser_warnings + type_checker_warnings
    end

    def unchecked_ast
      @cache
        .values
        .select(Tuple(Ast, Array(Warning)))
        .map { |item| item[0] }
        .reduce(Ast.new) { |memo, item| memo.merge item }
        .tap do |item|
          # Only merge the core if it's not the core (if it has `Maybe`
          # defined then it's the core). This is so the language server
          # works with the core files.
          unless item.type_definitions.index(&.name.==("Maybe"))
            item.merge(Core.ast)
          end
        end
        .normalize
    end

    def nodes_at_cursor(
      *,
      column : Int64,
      path : String,
      line : Int64,
    ) : Array(Ast::Node) | Error
      map_error(ast, &.nodes_at_cursor(
        line: line, column: column, path: path))
    end

    def nodes_at_path(path : String)
      map_error(ast, &.nodes_at_path(path))
    end

    def formatter_config
      MintJson.parse?(@path, search: true).try(&.formatter) ||
        Formatter::Config.new
    end

    def format(node : Ast::Node?) : String?
      Formatter.new(formatter_config).format!(node)
    end

    def format(path : String) : String | Error?
      case item = ast(path)
      in Ast
        Formatter.new(formatter_config).format(item)
      in Error, Nil
        item
      end
    end

    def reset
      @cache.clear
      @watcher.patterns =
        SourceFiles.everything(
          MintJson.parse(@path, search: true),
          include_tests: @include_tests,
          dot_env: @dot_env)
    rescue error : Error
      set(error)
    end

    def check
      Logger.log "Type Checking" do
        if error = @cache.values.select(Error).first?
          error
        else
          TypeChecker.new(
            check_everything: @check.unreachable?,
            check_env: @check.environment?,
            ast: unchecked_ast
          ).tap(&.check(@checked_entities))
        end
      end
    rescue error : Error
      error
    rescue exception : Exception
      Mint::Error.new(:type_checking_failed).tap do |error|
        error.block do
          text "You have run into an unexpected error during type checking."
          text "Please create an issue about this!"
        end

        error.snippet exception.to_s
        error.snippet "This is the stack trace:", exception.backtrace.join("\n")
      end
    end

    def update(files : Array(String), reason : Symbol)
      actions = [] of Symbol

      Logger.log "Parsing files" do
        files.each do |file|
          if File.extname(file) == ".mint"
            if File.exists?(file)
              contents = File.read(file)
              update(contents, file)

              if @format
                case ast = ast(file)
                when Ast
                  formatted =
                    Formatter.new(formatter_config).format(ast) + "\n"

                  if formatted != contents
                    File.write(file, formatted)
                  end
                end
              end
            else
              delete(file)
            end

            actions << :compile
          else
            # We need to do a reset because:
            # 1. packages could have changed
            # 2. source directories could have changed
            # 3. variables in the .env file could have changed
            if file == @dot_env
              Env.init(file)
            end

            actions << :reset
          end
        end
      end

      if actions.includes?(:reset) && reason == :modified
        reset
      elsif actions.includes?(:compile)
        set(check)
      end
    end

    private def set(value : TypeChecker | Error) : Nil
      @result = Result.new(value, warnings(value))
      @listener.try(&.call(@result))
    end

    private def map_error(item : T | Error, & : T -> R) : R | Error forall T, R
      case item
      in Error
        item
      in T
        yield item
      end
    end
  end
end
