module Mint
  class Formatter
    class Config
      getter indent_size

      def initialize(@indent_size : Int64 | Int32 = 2)
      end
    end

    getter ast, config

    def initialize(@ast : Ast, @config : Config = Config.new)
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

    def format(node : Ast::Node) : String
      raise "Formatter not implemented for node '#{node}' (this should not happen!)"
    end
  end
end
