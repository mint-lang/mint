module Mint
  # This class if for logging timings. It supports nesting timings
  # and printing them in a tree.
  module Logger
    extend self

    class Log
      # The elapsed time of the log.
      property elapsed = Time::Span.new(nanoseconds: 0)

      # The child logs.
      getter logs = Array(Log).new

      # The mssage.
      getter message : String

      def initialize(@message)
      end

      # The real time of the log.
      def real : Time::Span
        elapsed - logs.sum(&.real)
      end

      # Processes the logs for printing.
      def print : Array(Tuple(String, Time::Span))
        logs
          .flat_map(&.print)
          .map { |(item, elapsed)| {item.indent, elapsed} }
          .unshift({message, real})
      end
    end

    # The current log, calls new logs will be nested in this one.
    @@current : Log | Array(Log) = [] of Log

    # Prints the gathered logs.
    def print(io)
      logs =
        case item = @@current
        in Log
          item.print
        in Array(Log)
          item.flat_map(&.print)
        end

      width =
        logs.max_of(&.first.size)

      logs.each do |(message, elapsed)|
        formatted =
          TimeFormat.auto(elapsed).colorize.mode(:bold)

        io.puts "#{message.ljust(width)} | #{formatted}"
      end
    end

    # Logs the message with the block elapsed time.
    def log(message, &)
      log =
        Log.new(message)

      previous = @@current
      @@current = log

      case previous
      in Log
        previous.logs << log
      in Array(Log)
        previous << log
      end

      start =
        Time.monotonic

      yield.tap do
        log.elapsed = Time.monotonic - start
        @@current = previous
      end
    end
  end
end
