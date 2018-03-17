class SyntaxError < Exception
  getter position, input, file

  def initialize(@input : String, @position : Int32, @file : String)
  end

  def message
    Messages
      .read(template)
      .gsub(/\{{2}file\:([^\}]*)\}{2}/) { |_, match| "" } # Messages.read match[1] }
      .gsub(/\{{2}([^\}]*)\}{2}/) { |_, match| locals[match[1]]? || "" }
  end

  def locals
    {
      "snippet" => snippet,
      "got"     => got,
      "char"    => char,
    }
  end

  def snippet
    Snippet.render(
      Ast::Node.new(
        input: Ast::Data.new(@input, @file),
        from: position,
        to: position + to))
  end

  def to
    input[position, input.size].split(/\s|\n|\r/).first.size
  end

  def part
    @input[position, to]
  end

  def got
    if part.size <= 1
      char
    else
      "<code>#{Snippet.escape(part)}</code>"
    end
  end

  def char
    char = input[position]

    case char
    when ' '
      "<b>a space</b>"
    when '\n', '\r'
      "<b>a new line</b>"
    else
      "<code>#{Snippet.escape(char.to_s)}</code>"
    end
  rescue
    "<b>the end of file</b>"
  end

  def template
    ""
  end
end
