module Mint
  class Debugger
    def initialize(@scope : TypeChecker::Scope)
    end

    def run
      @scope.levels.reverse.map_with_index do |level, index|
        debug(level).indent((index + 1) * 2)
      end.join("\n")
    end

    def debug(node : Ast::Node)
      ""
    end

    def debug(node : Tuple(String, TypeChecker::Checkable))
      "#{node[0]} => #{node[1].to_s}"
    end

    def debug(node : Ast::InlineFunction)
      node.arguments.map do |argument|
        "#{argument.name.value} => #{argument}"
      end.join("\n")
    end

    def debug(node : Ast::Function)
      arguments =
        node.arguments.map do |argument|
          "#{argument.name.value} => #{argument}"
        end.join("\n")

      statements =
        node.where.try do |where|
          where.statements.map do |statement|
            "#{statement.name.value} => #{statement}"
          end.join("\n")
        end.to_s

      [arguments, statements].join("\n")
    end

    def debug(node : Ast::Get)
      node.where.try do |where|
        where.statements.map do |statement|
          "#{statement.name.value} => #{statement}"
        end.join("\n")
      end.to_s
    end

    def debug(node : Ast::Module)
      node.functions.map do |function|
        "#{function.name.value} => #{function}"
      end.join("\n")
    end

    def debug(node : Ast::Store)
      functions =
        node.functions.map do |function|
          "#{function.name.value} => #{function}"
        end.join("\n")

      states =
        node.states.map do |state|
          "#{state.name.value} => #{state}"
        end.join("\n")

      gets =
        node.gets.map do |get|
          "#{get.name.value} => #{get}"
        end.join("\n")

      [functions, states, gets].join("\n")
    end

    def debug(node : Ast::Component)
      functions =
        node.functions.map do |function|
          "#{function.name.value} => #{function}"
        end.join("\n")

      states =
        node.states.map do |state|
          "#{state.name.value} => #{state}"
        end.join("\n")

      properties =
        node.properties.map do |state|
          "#{state.name.value} => #{state}"
        end.join("\n")

      gets =
        node.gets.map do |get|
          "#{get.name.value} => #{get}"
        end.join("\n")

      [functions, states, gets, properties].join("\n")
    end
  end
end
