require "colorize"
require "html"

module Render
  class Html
    getter io

    @io : IO

    def initialize(@io = IO::Memory.new, @width = 100)
    end

    def header(content)
      print "<h1>#{escape(content)}</h1>"
    end

    def block(text)
      title text
      print "<p>"
      with self yield
      print "</p>"
    end

    def divider
      print "<hr>"
    end

    def title(content)
      print "<h2>#{escape(content)}</h2>"
    end

    def code(content)
      print "<code>#{escape(content)}</code>"
    end

    def text(content)
      print escape(content)
    end

    def escape(code)
      HTML.escape(code.gsub('\\', "\\\\").gsub('`', "\\`"))
    end

    def render
      with self yield
      puts io
    end
  end

  class Terminal
    class_getter stdout
    @@stdout = Terminal.new(STDOUT)

    getter cursor, width, io, last

    @io : IO

    def initialize(@io = IO::Memory.new, @width = 100)
      @cursor = 0
      @last = ""
    end

    def render
      with self yield
      print "\n" unless last =~ /\n|\r/
    end

    def block(text)
      title text do
        with self yield
        print "\n"
      end
    end

    def header(text)
      process text do |part|
        part.colorize.mode(:bold)
      end
      print "\n"
    end

    def divider
      print ("᐀" * 100).colorize.mode(:dim).to_s + "\n"
    end

    def title(text)
      @cursor = 0
      title_divider text
      with self yield
      title_divider
    end

    def title_divider(text = nil)
      content =
        if text
          "-- #{text.upcase} "
        else
          ""
        end

      divider =
        if content.size < @width
          "-" * (@width - content.size)
        end

      io.print "#{content}#{divider}\n".colorize(:light_cyan).mode(:dim)
    end

    def print(contents)
      @last =
        contents[contents.size - 1].to_s

      io.print contents
    end

    def text(contents)
      process contents do |part|
        part
      end
    end

    def code(contents)
      process "\"#{contents}\"" do |part|
        part.colorize(:light_yellow).mode(:bold)
      end
    end

    def bold(contents)
      process contents do |part|
        part.colorize(:light_yellow).mode(:bold)
      end
    end

    def process(contents)
      index = 0
      part = ""

      loop do
        char = contents[index]?.try(&.to_s)

        if ((char && char =~ /\s|\n|\r/) || !char) && part.size > 0
          if cursor > @width
            @cursor = part.size
            print "\n"
          end

          print (yield part).to_s
          part = ""
        end

        break unless char

        case char
        when "\n", "\r"
          @cursor = 0
        when .=~(/\s/)
          @cursor += char.size
          print char
        else
          @cursor += char.size
          part += char
        end

        index += 1
      end
    end
  end
end
