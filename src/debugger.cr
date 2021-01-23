module Mint
  class Debugger
    def initialize(@scope : TypeChecker::Scope)
    end

    def run
      @scope.levels.reverse.map_with_index do |level, index|
        debug(level).indent((index + 1) * 2)
      end.join('\n')
    end

    def debug(node : Ast::Node)
      "#{node}"
    end

    def debug(node : Tuple(String, TypeChecker::Checkable, Ast::Node))
      "#{node[0]} => #{node[1]}"
    end

    def debug(node : Tuple(String, TypeChecker::Checkable))
      "#{node[0]} => #{node[1]}"
    end

    def debug(node : Ast::InlineFunction)
      node.arguments.join('\n') do |argument|
        "#{argument.name.value} => #{argument}"
      end
    end

    def debug(node : Ast::Function)
      arguments =
        node.arguments.join('\n') do |argument|
          "#{argument.name.value} => #{argument}"
        end

      statements =
        node.where.try do |where|
          where.statements.join('\n') do |statement|
            "#{statement.target.class.name} => #{statement}"
          end
        end.to_s

      {arguments, statements}.join('\n')
    end

    def debug(node : Ast::Get)
      node.where.try do |where|
        where.statements.join('\n') do |statement|
          "#{statement.target.class.name} => #{statement}"
        end
      end.to_s
    end

    def debug(node : Ast::Module)
      node.functions.join('\n') do |function|
        "#{function.name.value} => #{function}"
      end
    end

    def debug(node : Ast::Store)
      functions =
        node.functions.join('\n') do |function|
          "#{function.name.value} => #{function}"
        end

      states =
        node.states.join('\n') do |state|
          "#{state.name.value} => #{state}"
        end

      gets =
        node.gets.join('\n') do |get|
          "#{get.name.value} => #{get}"
        end

      {functions, states, gets}.join('\n')
    end

    def debug(node : Ast::Component)
      functions =
        node.functions.join('\n') do |function|
          "#{function.name.value} => #{function}"
        end

      states =
        node.states.join('\n') do |state|
          "#{state.name.value} => #{state}"
        end

      properties =
        node.properties.join('\n') do |state|
          "#{state.name.value} => #{state}"
        end

      gets =
        node.gets.join('\n') do |get|
          "#{get.name.value} => #{get}"
        end

      {functions, states, gets, properties}.join('\n')
    end
  end
end
