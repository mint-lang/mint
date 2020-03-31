module Mint
  module Render
    class Terminal
      class Block
        getter io : IO

        def initialize(@io = IO::Memory.new, @width = 50)
          @cursor = 0
          @last = ""
        end

        def close
          puts unless @last.in?("\n", "\r")
        end

        def print(contents : String)
          @last = contents.last
          @io.print contents
        end

        def print(contents)
          print contents.to_s
        end

        def puts(contents = nil)
          print contents if contents
          print "\n"
        end

        def text(contents)
          process(contents + " ")
        end

        def code(contents)
          actual_content =
            case contents
            when " ", ""
              "a space"
            when "\n"
              "a new line"
            when "\0"
              "end of file"
            else
              contents
            end

          process "\"#{actual_content}\" " do |part|
            part.colorize(:light_yellow).mode(:bold)
          end
        end

        def bold(contents)
          process(contents + " ") do |part|
            part.colorize(:light_yellow).mode(:bold)
          end
        end

        def process(contents)
          process(contents) { |part| part }
        end

        def process(contents)
          index = 0
          part = ""

          loop do
            char = contents[index]?

            if ((char && char.whitespace?) || !char) && part.size > 0
              if @cursor > @width
                @cursor = part.size
                puts
              end

              print yield part
              part = ""
            end

            break unless char

            case char
            when '\n', '\r'
              @cursor = 0
              print char
            when .whitespace?
              @cursor += 1
              print char
            else
              @cursor += 1
              part += char
            end

            index += 1
          end
        end
      end

      STDOUT = Terminal.new(::STDOUT)

      getter width, io, position

      @io : IO

      def initialize(@io = IO::Memory.new, @width = 80)
        @position = 0
      end

      def self.render
        terminal = new
        with terminal yield
        terminal.io
      end

      def render
        with self yield
      end

      def render(io)
        print io
      end

      def block
        block = Block.new(width: @width)
        with block yield
        block.close
        puts block.io
      end

      def measure(message)
        print message
        result = nil
        elapsed = Time.measure { result = yield }
        puts TimeFormat.auto(elapsed).colorize.mode(:bold)
        result
      end

      def type(contents)
        pre contents.to_pretty
      end

      def list(data)
        data.each do |item|
          print ("• " + item.indent.lstrip)
            .indent
            .colorize(:light_yellow)
            .mode(:bold)

          print "\n\n"
        end
      end

      def type_list(data)
        list data.map(&.to_pretty)
      end

      def pre(contents)
        print contents.indent.colorize(:light_yellow).mode(:bold)
        print "\n\n"
      end

      def snippet(node)
        print TerminalSnippet.render(node.input.input, node.input.file, node.from, node.to, width: @width)
        print "\n\n"
      end

      def header(text)
        puts text.colorize.mode(:bold)
      end

      def divider
        puts ("━" * @width).colorize(:dark_gray).mode(:dim)
      end

      def title(text)
        content =
          if text
            "#{"░".colorize.mode(:dim)} #{text.upcase.colorize(:light_cyan).mode(:bold)} "
          else
            ""
          end

        divider =
          if content.size < @width
            ("░" * (@width - text.size - 3)).colorize.mode(:dim)
          end

        io.print "#{content}#{divider}\n\n"
      end

      def print(contents : String)
        @position += contents.size
        io.print contents
      end

      def print(contents)
        print contents.to_s
      end

      def puts(contents = nil)
        print contents if contents
        print "\n"
      end
    end
  end
end
