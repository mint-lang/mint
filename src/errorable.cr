module Mint
  # This module is used in all of things which can error out (parser, type
  # checker, scope builder, etc...)
  module Errorable
    def unreachable!(message : String)
      error! :unreachable do
        block do
          text "You have run into unreachable code."
          text "Please create an issue about this!"
        end

        snippet message
        snippet "This is the stack trace:", caller.join("\n")
      end
    end

    def error!(name : Symbol, &)
      raise Mint::Error.new(name).tap { |error| with error yield }
    end
  end

  # Represents a raisable rich and descriptive error. The error can be built
  # using a DLS.
  class Error < Exception
    # Anything that can be a snippet.
    alias SnippetTarget = TypeChecker::Checkable | SnippetData |
                          Ast::Node | Parser | String |
                          Tuple(Parser, Parser::Location)

    alias Element = Text | Bold | Code

    record Snippet, value : TypeChecker::Checkable | String | SnippetData
    record Code, value : String
    record Bold, value : String
    record Text, value : String

    record SnippetData,
      location : {Parser::Location, Parser::Location},
      filename : String,
      input : String,
      path : String,
      from : Int64,
      to : Int64

    # The message is based on blocks of elements. The blocks are separated
    # by double new lines.
    getter blocks = [] of Array(Element) | Snippet

    # The name of the error.
    getter name : Symbol

    getter location : SnippetData? do
      blocks.select(Snippet).compact_map do |snippet|
        case value = snippet.value
        when SnippetData
          value
        end
      end.first?
    end

    def initialize(@name : Symbol)
      @current = [] of Element
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

    def snippet(value : String, node : SnippetTarget)
      block value
      snippet node
    end

    def snippet(value : SnippetTarget)
      target =
        case value
        in Tuple(Parser, Parser::Location)
          parser, position =
            value

          min =
            parser.input[position.offset]? == '\0' ? 0 : 1

          SnippetData.new(
            to: position.offset + [min, parser.word(position).to_s.size].max,
            filename: parser.file.relative_path,
            location: {position, position},
            input: parser.file.contents,
            path: parser.file.path,
            from: position.offset)
        in Parser
          min =
            value.char == '\0' ? 0 : 1

          SnippetData.new(
            to: value.position.offset + [min, value.word.to_s.size].max,
            location: {value.position, value.position},
            filename: value.file.relative_path,
            from: value.position.offset,
            input: value.file.contents,
            path: value.file.path)
        in Ast::Node
          SnippetData.new(
            filename: value.file.relative_path,
            location: {value.from, value.to},
            input: value.file.contents,
            from: value.from.offset,
            path: value.file.path,
            to: value.to.offset)
        in SnippetData
          value
        in TypeChecker::Checkable
          value
        in String
          value
        end

      @blocks << Snippet.new(target)
    end

    def expected(
      subject : TypeChecker::Checkable | String,
      got : TypeChecker::Checkable,
    )
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

    def to_terminal
      renderer = Render::Terminal.new
      renderer.title "ERROR (#{name})"

      blocks.each do |element|
        case element
        in Error::Snippet
          renderer.snippet element.value
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

    def to_s
      to_terminal.to_s
    end
  end
end
