module Mint
  # A simple class for building HTML using the built-in `XML::Builder`.
  #
  # We only support tags that we actually need, which are deletaged to the
  # `XML::Builder#element` method. <script> is handled differently since it
  #  explicitly needs a closing tag.
  class HtmlBuilder
    def self.build(*, optimize : Bool, doctype : Bool = true, &)
      html =
        XML.build_fragment(indent: optimize ? nil : "  ") do |xml|
          builder = new(xml)

          with builder yield builder
        end

      header =
        if doctype
          "<!DOCTYPE html>#{optimize ? "" : "\n"}"
        end

      "#{header}#{html}"
    end

    def initialize(@xml : XML::Builder)
    end

    def tag(tag, attributes, &)
      @xml.element(tag, attributes) { with self yield }
    end

    def script(**attributes, &)
      @xml.element("script", **attributes) { with self yield }
    end

    def script(**attributes)
      script(**attributes) { text("") }
    end

    def a(**attributes, &)
      @xml.element("a", **attributes) { with self yield }
    end

    def a(**attributes)
      a(**attributes) { text("") }
    end

    def text(contents)
      @xml.text(contents)
    end

    def raw(contents)
      @xml.raw(contents)
    end

    {% for tag in %w(html head body meta link pre code noscript div span h1 h2
                    h3 title aside article nav strong) %}
      def {{tag.id}}(**attributes)
        @xml.element("{{tag.id}}", **attributes)
      end

      def {{tag.id}}(**attributes)
        @xml.element("{{tag.id}}", **attributes) do
          with self yield
        end
      end
    {% end %}
  end
end
