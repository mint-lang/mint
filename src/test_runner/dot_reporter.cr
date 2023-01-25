require "./reporter"

module Mint
  class TestRunner
    class DotReporter < Reporter
      private MAX_LINE_LENGTH = 80

      private SUCCESS_MARKER = ".".colorize(:green)
      private FAIL_MARKER    = "F".colorize(:red)
      private ERROR_MARKER   = "E".colorize(:red)

      def initialize
        @count = 0
      end

      def with_count(&)
        puts if @count > 0 && @count % MAX_LINE_LENGTH == 0
        yield
        @count += 1
      end

      def succeeded(name)
        with_count do
          print SUCCESS_MARKER
        end
      end

      def failed(name, error)
        with_count do
          print FAIL_MARKER
        end
      end

      def errored(name, error)
        with_count do
          print ERROR_MARKER
        end
      end

      def suite(name)
      end

      def done
        puts
      end

      def crashed(message)
        puts
        puts "❗ An internal error occurred while executing a test: #{message}".colorize(:red)
      end
    end
  end
end
