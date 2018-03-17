struct HTML::Builder
  def meta(**attrs)
    @str << "<meta"
    append_attributes_string(**attrs)
    @str << ">"
  end

  def style
    @str << "<style>"
    yield
    @str << "</style>"
  end
end
