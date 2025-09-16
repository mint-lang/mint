module Mint
  class TestRunner
    class Reporter
      getter messages = [] of Message
      getter? failed = false

      def reset
        @messages = [] of Message
      end

      def process(message : Message)
        @failed =
          message.type.in?("FAILED", "ERRORED", "CRASHED") unless @failed

        case message.type
        when "FAILED", "ERRORED", "SUCCEEDED"
          @messages << message
        when "LOG"
          terminal.puts message.result
        when "CRASHED"
          terminal.puts
          terminal.puts "❗ An internal error occurred while executing a test: #{message.result}".colorize(:red)
        end
      end

      def report
        succeeded =
          @messages.count(&.type.==("SUCCEEDED"))

        failed =
          @messages.select(&.type.==("FAILED"))

        errored =
          @messages.select(&.type.==("ERRORED"))

        terminal.divider
        terminal.puts "#{@messages.size} tests"
        terminal.puts "  #{ARROW} #{succeeded} passed"
        terminal.puts "  #{ARROW} #{failed.size} failed"
        terminal.puts "  #{ARROW} #{errored.size} errored"

        (failed + errored)
          .group_by(&.suite.to_s)
          .to_a
          .sort_by!(&.first)
          .each do |suite, failures|
            terminal.puts (suite.presence || "N/A")
              .indent(4)
              .colorize(:red)

            failures.each do |failure|
              terminal.puts "- #{failure.name}"
                .indent(6)
                .colorize(:red)

              terminal.puts "|> #{failure.result.presence || "N/A"}"
                .indent(8)
                .colorize(:red)

              if location = failure.location
                terminal.puts "<| #{location.filename}:#{location.start[0]}"
                  .indent(8)
                  .colorize(:dark_gray)
              end
            end
          end
      end

      private def terminal
        Render::Terminal::STDOUT
      end
    end
  end
end
