require "./reporter"

module Mint
  class TestRunner
    class DocumentationReporter < Reporter
      def process(message : Message)
        super

        case message.type
        when "SUITE"
          terminal.puts message.suite
        when "SUCCEEDED"
          terminal.puts "✔ #{message.name}".colorize(:green).to_s.indent
        when "FAILED"
          terminal.puts "✘ #{message.name}".colorize(:red).to_s.indent
          terminal.puts message.result.colorize(:red).to_s.indent(4)
        when "ERRORED"
          terminal.puts "An error occurred when running the test #{message.name}: #{message.result}".colorize(:red)
        end
      end
    end
  end
end
