# These add support for writing raw text when builing XML.
lib LibXML
  fun xmlTextWriterWriteRaw(TextWriter, content : UInt8*) : Int
end

class XML::Builder
  def raw(content : String) : Nil
    call WriteRaw, string_to_unsafe(content)
  end
end
