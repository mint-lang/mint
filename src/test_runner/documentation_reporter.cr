module Mint
  class TestRunner
    class DocumentationReporter
      def succeeded(name)
        puts "✔ #{name}".colorize(:green).to_s.indent
      end

      def failed(name, error)
        puts "✘ #{name}".colorize(:red).to_s.indent
        puts error.colorize(:red).to_s.indent(4)
      end

      def suite(name)
        puts name
      end

      def done
      end

      def crashed(message)
        puts "❗ An internal error occurred while executing a test: #{message}".colorize(:red)
      end
    end
  end
end
