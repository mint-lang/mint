class TypeError < Exception
  getter locals

  def initialize(@locals = {} of String => String | Ast::Node)
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

  def instance
    Message.new(locals)
  end
end
