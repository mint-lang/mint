require "./reporter"

module Mint
  class TestRunner
    class DotReporter < Reporter
      # The maximum length of a line of dots.
      private MAX_LINE_LENGTH = 80

      # Characters for some states
      private SUCCESS_MARKER = ".".colorize(:green)
      private ERROR_MARKER   = "E".colorize(:red)
      private FAIL_MARKER    = "F".colorize(:red)

      @count = 0

      def reset
        @count = 0
        super
      end

      def with_count(&)
        puts if @count > 0 && @count % MAX_LINE_LENGTH == 0
        yield
        @count += 1
      end

      def report
        puts
        super
      end

      def process(message : Message)
        case message.type
        when "LOG"
          # We restart the count because the parent class
          # displays the log.
          @count = 0
        when "SUCCEEDED"
          with_count { print SUCCESS_MARKER }
        when "FAILED"
          with_count { print FAIL_MARKER }
        when "ERRORED"
          with_count { print ERROR_MARKER }
        end

        super
      end
    end
  end
end
