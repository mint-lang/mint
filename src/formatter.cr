require "digest/md5"

module Mint
  class Formatter
    class Config
      getter indent_size

      def initialize(@indent_size : Int64 | Int32 = 2)
      end
    end

    getter ast, config

    def initialize(@ast : Ast, @config : Config = Config.new)
      @skip = [] of {String, String}
    end

    def indent(string : String)
      string.indent(config.indent_size.to_i32)
    end

    def replace_skipped(result)
      @skip.reverse.reduce(result) do |memo, (digest, item)|
        memo.sub(digest, item)
      end
    end

    def skip
      result =
        yield

      digest =
        Digest::MD5.hexdigest(result)

      @skip << {digest, result}

      digest
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

    def source(node : Ast::Node) : String
      replace_skipped(format(node))
    end
  end
end
