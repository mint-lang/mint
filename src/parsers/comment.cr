module Mint
  class Parser
    def comment : Ast::Comment?
      parse do |start_position|
        content, type, next_comment =
          if word! "/*"
            consumed =
              gather { consume { !word?("*/") && !eof? } }.to_s

            next error :comment_expected_closing_tag do
              expected "the closing tag of a comment", word
              snippet self
            end unless word! "*/"

            {consumed, Ast::Comment::Type::Block, nil}
          elsif word! "//"
            consumed =
              gather { consume { char != '\n' && !eof? } }.to_s

            comment =
              parse do
                spaces = gather { whitespace }.to_s
                next unless word?("//") && spaces.count('\n') == 1
                self.comment
              end

            {consumed, Ast::Comment::Type::Inline, comment}
          else
            {nil, Ast::Comment::Type::Block, nil}
          end

        next unless content

        Ast::Comment.new(
          next_comment: next_comment,
          from: start_position,
          content: content,
          to: position,
          type: type,
          file: file)
      end
    end
  end
end
