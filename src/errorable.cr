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

    def to_html
      renderer = Render::Html.new
      renderer.title "ERROR (#{name})"

      blocks.each do |element|
        case element
        # when TypeList
        #   renderer.type_list element.value
        # when StringList
        #   renderer.list element.value
        # when Pre
        #   renderer.pre element.value
        # when Type
        #   renderer.type element.value
        # when Title
        #   renderer.title element.value
        when Error::Snippet
          case node = element.value
          when TypeChecker::Checkable
            renderer.pre node.to_pretty
          when Ast::Node
            renderer.snippet node
          end
        when Array(Error::Element)
          renderer.block do
            element.each do |item|
              case item
              when Error::Text
                text item.value
              when Error::Bold
                bold item.value
              when Error::Code
                code item.value
              end
            end
          end
        end
      end

      # ameba:disable Lint/UselessAssign
      contents =
        renderer.io.to_s

      ECR.render("#{__DIR__}/message.ecr")
    end

    def to_terminal
      renderer = Render::Terminal.new
      renderer.title "ERROR (#{name})"

      blocks.each do |element|
        case element
        # when TypeList
        #   renderer.type_list element.value
        # when StringList
        #   renderer.list element.value
        # when Pre
        #   renderer.pre element.value
        # when Type
        #   renderer.type element.value
        # when Title
        #   renderer.title element.value
        when Error::Snippet
          case node = element.value
          when TypeChecker::Checkable
            renderer.snippet node
          when Ast::Node
            renderer.snippet node
          when String
            renderer.snippet node
          end
        when Array(Error::Element)
          renderer.block do
            element.each do |item|
              case item
              when Error::Text
                text item.value
              when Error::Bold
                bold item.value
              when Error::Code
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
