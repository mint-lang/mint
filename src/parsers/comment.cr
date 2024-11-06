module Mint
  class Parser
    def comment : Ast::Comment?
      parse do |start_position|
        content, type, next_comment, to =
          if word! "/*"
            consumed =
              gather { consume { !word?("*/") && !eof? } }.to_s

            next error :comment_expected_closing_tag do
              expected "the closing tag of a comment", word
              snippet self
            end unless word! "*/"

            {consumed, Ast::Comment::Type::Block, nil, position}
          elsif word! "//"
            consumed =
              gather { consume { char != '\n' && !eof? } }.to_s

            to_position =
              position

            comment =
              parse do
                spaces = gather { whitespace }.to_s
                next unless word?("//") && spaces.count('\n') == 1
                self.comment
              end

            {consumed, Ast::Comment::Type::Inline, comment, to_position}
          else
            {nil, Ast::Comment::Type::Block, nil, position}
          end

        next unless content

        Ast::Comment.new(
          next_comment: next_comment,
          from: start_position,
          content: content,
          type: type,
          file: file,
          to: to)
      end
    end
  end
end
