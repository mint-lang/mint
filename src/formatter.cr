module Mint
  class Formatter
    include Skippable

    class Config
      getter indent_size : Int32

      def initialize(@indent_size = 2)
      end
    end

    getter ast : Ast
    getter config : Config

    def initialize(@ast, @config = Config.new)
    end

    def indent(string : String)
      string.indent(config.indent_size.to_i32)
    end

    # Helpers for formatting things
    # --------------------------------------------------------------------------

    def format(node : Ast::Expression,
               head_comment : Ast::Comment?,
               tail_comment : Ast::Comment?)
      head =
        head_comment.try { |item| "#{format item}\n" }

      tail =
        tail_comment.try { |item| "\n#{format item}" }

      body =
        format node

      "#{head}#{body}#{tail}"
    end

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

    def format_enum_record_definition(node : Ast::EnumRecordDefinition) : String
      if node.new_line?
        fields =
          format node.fields, ",\n"

        "\n#{indent(fields)}"
      else
        format node.fields, ", "
      end
    end

    def format(node : Ast::Node) : String
      # This is required because the overloaded
      case node
      when Ast::EnumRecordDefinition
        format_enum_record_definition(node)
      else
        raise "Formatter not implemented for node '#{node}' (this should not happen!)"
      end
    end

    def source(node : Ast::Node) : String
      replace_skipped(format(node))
    end
  end
end
