module Mint
  module TimeFormat
    SECONDS_IN_MINUTE      =        60
    MILLISECONDS_IN_SECOND =     1_000
    MICROSECONDS_IN_SECOND = 1_000_000

    def self.auto(time : Time::Span) : String
      time_f = time.to_f

      return minutes(time_f) if time_f / SECONDS_IN_MINUTE >= 1
      return seconds(time_f) if time_f >= 1
      return milliseconds(time_f) if time_f * MILLISECONDS_IN_SECOND >= 1
      microseconds(time_f)
    end

    private def self.minutes(time_f : Float) : String
      "#{(time_f / SECONDS_IN_MINUTE).round(2)}m"
    end

    private def self.seconds(time_f : Float) : String
      "#{time_f.round(3)}s"
    end

    private def self.milliseconds(time_f : Float) : String
      "#{(time_f * MILLISECONDS_IN_SECOND).round(3)}ms"
    end

    private def self.microseconds(time_f : Float) : String
      "#{(time_f * MICROSECONDS_IN_SECOND).to_i}μs"
    end
  end
end
