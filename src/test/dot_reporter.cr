module Mint
  class Test
    class DotReporter
      def succeeded(name)
        print ".".colorize(:green).to_s
      end

      def failed(name, error)
        print ".".colorize(:red).to_s
      end

      def suite(name)
      end

      def done
        print "\n"
      end
    end
  end
end
