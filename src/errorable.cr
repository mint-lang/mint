module Mint
  # This module is used in all of the stages of the compiler which can error
  # out (parser, type checker, scope builder, etc...).
  #
  # It defines an interface (method) for creating descriptive errors and it can
  # either gather them or raise them depending on the raise errors flag, which
  # the including entity must define (unusally in the initialize method).
  module Errorable
    # The errors found during parsing.
    getter errors : Array(Error) = [] of Error

    def self.error(name : Symbol, &)
      raise Error.new(name).tap { |error| with error yield }
    end

    def error!(name : Symbol, &)
      raise Error.new(name).tap { |error| with error yield }
    end

    def error(name : Symbol, &)
      errors << Error.new(name).tap { |error| with error yield }
      nil
    end
  end

  # Represents a raisable rich and descriptive error.
  class Error < Exception
    alias Element = Text | Bold | Code

    record Snippet, value : Ast::Node | String | TypeChecker::Checkable
    record Code, value : String
    record Bold, value : String
    record Text, value : String

    getter blocks = [] of Array(Element) | Snippet
    getter name : Symbol

    def initialize(@name : Symbol)
      @current = [] of Element
    end

    def build(&)
      with self yield
    end

    def block(&)
      with self yield
      @blocks << @current
      @current = [] of Element
    end

    def block(contents : String)
      block { text(contents) }
    end

    def code(value : String)
      @current << Code.new(value)
    end

    def text(value : String)
      @current << Text.new(value)
    end

    def bold(value : String)
      @current << Bold.new(value)
    end

    def snippet(value : String, node : Ast::Node | TypeChecker::Checkable | String)
      block value
      snippet node
    end

    def snippet(value : Parser)
      from =
        value.position

      to =
        value.position + value.word.to_s.size

      snippet(Ast::Node.new(file: value.file, from: from, to: to))
    end

    def snippet(value : String | Ast::Node | TypeChecker::Checkable)
      @blocks << Snippet.new(value)
    end

    def expected(subject : TypeChecker::Checkable | String, got : TypeChecker::Checkable)
      snippet "I was expecting:", subject
      snippet "Instead it is:", got
    end

    def expected(subject : String, got : String)
      block do
        text "I was expecting #{subject} but I found"
        code got
        text "instead:"
      end
    end

    def to_html(reload : Bool = false)
      HtmlBuilder.build(optimize: true) do
        html do
          head do
            meta charset: "utf-8"
            meta content: "width=device-width, initial-scale=1, shrink-to-fit=no",
              name: "viewport"

            if reload
              script src: "/live-reload.js"
            end
          end

          body { pre { code { text to_terminal.to_s.uncolorize } } }
        end
      end
    end

    def to_terminal
      renderer = Render::Terminal.new
      renderer.title "ERROR (#{name})"

      blocks.each do |element|
        case element
        in Error::Snippet
          case node = element.value
          in TypeChecker::Checkable
            renderer.snippet node
          in Ast::Node
            renderer.snippet node
          in String
            renderer.snippet node
          end
        in Array(Error::Element)
          renderer.block do
            element.each do |item|
              case item
              in Error::Text
                text item.value
              in Error::Bold
                bold item.value
              in Error::Code
                code item.value
              end
            end
          end
        end
      end

      renderer.io
    end
  end
end
