class TypeError < Exception
  getter locals

  def initialize(@locals = {} of String => String)
  end

  def message
    Messages
      .read(template)
      .gsub(/\{{2}([^\}]*)\}{2}/) { |_, match| locals[match[1]]? || "" }
  end

  def template
    ""
  end
end
