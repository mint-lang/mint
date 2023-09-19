module Mint
  class Parser
    def comment : Ast::Comment?
      parse do |start_position|
        content, type =
          if word! "/*"
            consumed =
              gather { consume { !word?("*/") && !eof? } }.to_s

            next error :comment_expected_closing_tag do
              expected "the closing tag of a comment", word
              snippet self
            end unless word! "*/"

            {consumed, Ast::Comment::Type::Block}
          elsif word! "//"
            consumed =
              gather { consume { char != '\n' && !eof? } }.to_s

            {consumed, Ast::Comment::Type::Inline}
          else
            {nil, Ast::Comment::Type::Block}
          end

        whitespace # TODO: Figure out why is this is needed
        next unless content

        Ast::Comment.new(
          from: start_position,
          content: content,
          to: position,
          type: type,
          file: file)
      end
    end
  end
end
