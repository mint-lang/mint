module Mint
  # This module contains the shared DSL for building rich, descriptive messages
  # (used by both Error and Warning).
  module Message
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

    @current = [] of Element

    # The message is based on blocks of elements. The blocks are separated
    # by double new lines.
    getter blocks = [] of Array(Element) | Snippet

    # The name of the message.
    getter name : Symbol

    getter locations : Array(SnippetData) do
      blocks.select(Snippet).compact_map do |snippet|
        case value = snippet.value
        when SnippetData
          value
        end
      end
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

    def to_terminal(title : String)
      renderer = Render::Terminal.new
      renderer.title "#{title} (#{name})"

      blocks.each do |element|
        case element
        when Snippet
          renderer.snippet element.value
        when Array(Element)
          renderer.block do
            element.each do |item|
              case item
              when Text
                text item.value
              when Bold
                bold item.value
              when Code
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
