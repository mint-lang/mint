module Mint
  class Parser
    def html_fragment : Ast::HtmlFragment?
      parse do |start_position|
        next unless word!("<>")

        comments = [] of Ast::Comment
        children = [] of Ast::Node

        many { expression || comment }.each do |item|
          case item
          when Ast::Comment
            comments << item
          when Ast::Node
            children << item
          end
        end

        whitespace
        next error :html_fragment_expected_closing_tag do
          expected "the closing tag of an HTML fragment", word
          snippet self
        end unless word!("</>")

        Ast::HtmlFragment.new(
          from: start_position,
          children: children,
          comments: comments,
          to: position,
          file: file)
      end
    end
  end
end
