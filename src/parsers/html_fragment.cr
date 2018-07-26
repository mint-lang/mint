module Mint
  class Parser
    syntax_error HtmlFragmentExpectedClosingBracket
    syntax_error HtmlFragmentExpectedClosingTag

    def html_fragment : Ast::HtmlFragment | Nil
      start do |start_position|
        skip unless char! '<'

        # Test for closing tag
        whitespace
        skip if char! '/'

        key = html_attribute false, "key"
        whitespace

        char '>', HtmlFragmentExpectedClosingBracket

        children = [] of Ast::HtmlContent
        comments = [] of Ast::Comment

        many do
          html_content.as(Ast::HtmlContent | Ast::Comment | Nil)
        end.compact.each do |item|
          case item
          when Ast::HtmlContent
            children << item
          when Ast::Comment
            comments << item
          end
        end

        whitespace
        keyword! "</>", HtmlFragmentExpectedClosingTag

        Ast::HtmlFragment.new(
          from: start_position,
          children: children,
          comments: comments,
          to: position,
          input: data,
          key: key)
      end
    end
  end
end
