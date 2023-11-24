module Mint
  # A simple class for building HTML using the built-in `XML::Builder`.
  #
  # We only support tags that we actually need, which are deletaged to the
  # `XML::Builder#element` method. <script> is handled differently since it
  #  explicitly needs a closing tag.
  class HtmlBuilder
    def self.build(*, optimize : Bool, &)
      html =
        XML.build_fragment(indent: optimize ? nil : "  ") do |xml|
          with new(xml) yield
        end

      "<!DOCTYPE html>#{optimize ? "" : "\n"}#{html}"
    end

    def initialize(@xml : XML::Builder)
    end

    def raw(contents)
      @xml.raw(contents)
    end

    def text(contents)
      @xml.text(contents)
    end

    def script(**attributes)
      script(**attributes) { text("") }
    end

    def script(**attributes, &)
      @xml.element("script", **attributes) { with self yield }
    end

    {% for tag in %w(html head body meta link pre code noscript div) %}
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
