module Mint
  class Cli < Admiral::Command
    class Lint < Admiral::Command
      include Command

      define_help description: "Lints the project for syntax and type errors."

      define_flag json : Bool,
        description: "Output errors in a JSON format.",
        default: false

      def run
        ast = Ast.new.merge(Core.ast)
        json = MintJson.current

        warnings = [] of Warning
        errors = [] of Error

        SourceFiles
          .everything(json, include_tests: true)
          .select(&.ends_with?(".mint"))
          .reduce(ast) do |memo, pattern|
            Dir.glob(pattern) do |file|
              begin
                value, file_warnings =
                  Parser.parse_with_warnings(file)

                warnings.concat(file_warnings)

                case value
                when Error
                  errors << value
                when Ast
                  memo.merge(value)
                end
              rescue error : Error
                errors << error
              end
            end

            memo
          end

        begin
          type_checker = TypeChecker.new(ast).tap(&.check)
        rescue error : Error
          errors << error
        end if errors.empty?

        if type_checker
          warnings.concat(type_checker.warnings)
        end

        if flags.json
          items =
            json(errors) + json(warnings)

          terminal.puts(items.to_pretty_json) unless items.empty?
        else
          items = (errors + warnings).map(&.to_terminal)

          execute "Linting" do
            if items.empty?
              terminal.puts "No errors or warnings detected."
            else
              items.each do |item|
                terminal.print item
              end
            end
          end
        end

        exit(1) unless errors.empty?
      end

      private def json(items : Array(Error) | Array(Warning))
        items.flat_map do |item|
          message = item.to_terminal.to_s.uncolorize

          type = item.class.name.split("::").last.downcase

          if (locations = item.locations).empty?
            [{type: type, name: item.name.to_s.upcase, message: message}]
          else
            locations.map do |location|
              {
                start:   {character: location.location[0].column, line: location.location[0].line},
                end:     {character: location.location[1].column, line: location.location[1].line},
                name:    item.name.to_s.upcase,
                path:    location.path,
                message: message,
                type:    type,
              }
            end
          end
        end
      end
    end
  end
end
