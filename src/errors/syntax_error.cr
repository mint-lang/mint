class SyntaxError < Exception
  getter position, input, file

  def initialize(@input : String, @position : Int32, @file : String)
  end

  def message
    to_terminal
  end

  def to_terminal
    instance.to_terminal
  end

  def to_html
    instance.to_html
  end

  def locals
    {
      "snippet" => snippet,
      "got"     => got,
      "char"    => char,
    }
  end

  def node
    Ast::Node.new(
      input: Ast::Data.new(@input, @file),
      to: position + to,
      from: position)
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

  def instance
    Message.new({} of String => String | Ast::Node)
  end
end
