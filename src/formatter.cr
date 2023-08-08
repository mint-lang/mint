module Mint
  class Formatter
    include Helpers
    include Skippable

    class Config
      property indent_size : Int32

      def initialize(@indent_size = 2)
      end
    end

    getter config : Config

    def initialize(@config = Config.new)
    end

    def indent(string : String)
      string.indent(config.indent_size)
    end

    # Helpers for formatting things
    # --------------------------------------------------------------------------

    def format(nodes : Array(Ast::Node | String), separator : String) : String
      format(nodes).join(separator)
    end

    def format(nodes : Array(Ast::Node | String)) : Array(String)
      nodes.map { |node| format(node).as(String) }
    end

    def format(node : String) : String
      node
    end

    def format(node : Nil) : Nil
      nil
    end

    def format_parameters(parameters)
      return if parameters.empty?

      "(#{format(parameters, ", ")})"
    end

    def format_arguments(arguments : Array(Ast::Argument))
      return if arguments.empty?

      value =
        format arguments

      if value.sum { |string| replace_skipped(string).size } > 50
        "(\n#{indent(value.join(",\n"))}\n)"
      else
        "(#{value.join(", ")})"
      end
    end

    def format(node : Ast::Node) : String
      # This is required because the overloaded
      raise "Formatter not implemented for node '#{node}' (this should not happen!)"
    end

    def source(node : Ast::Node) : String
      replace_skipped(format(node))
    end
  end
end
