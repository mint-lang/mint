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
      part
    end
  end

  def char
    char = input[position]

    case char
    when ' '
      "a space"
    when '\n', '\r'
      "a new line"
    else
      char.to_s
    end
  rescue
    "the end of file"
  end

  def instance
    Message.new({} of String => String | Ast::Node)
  end
end
