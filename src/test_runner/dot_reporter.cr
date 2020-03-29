module Mint
  class TestRunner
    class DotReporter
      def initialize
        @count = 0
      end

      def with_count
        puts if @count > 0 && @count % 80 == 0
        yield
        @count += 1
      end

      def succeeded(name)
        with_count do
          print ".".colorize(:green)
        end
      end

      def failed(name, error)
        with_count do
          print "F".colorize(:red)
        end
      end

      def suite(name)
      end

      def done
        puts
      end
    end
  end
end
