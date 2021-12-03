/* Represents a duration (span) of time. */
enum Time.Span {
  Milliseconds(Number)
  Seconds(Number)
  Minutes(Number)
  Hours(Number)
  Days(Number)
  Weeks(Number)
  Months(Number)
  Years(Number)
}

/*
Utility functions for working with `Time`.

This module uses the `Date`[1] JavaScript object under the hood. Since the
`Date` object is always in the clients time-zone, this module modifies it's
UTC version with the `getUTC*` and `setUTC*` methods.

[1] https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date
*/
module Time {
  /*
  Tries to parse the given string as an ISO date.

    Time.fromIso("2018-04-05T00:00:00.000Z")
  */
  fun fromIso (raw : String) : Maybe(Time) {
    `
    (() => {
      try {
        return #{Maybe::Just(`new Date(#{raw})`)}
      } catch (error) {
        return #{Maybe::Nothing}
      }
    })()
    `
  }

  /*
  Formats the given time to the ISO format.

    Time.toIso(Tome.today()) == "2018-04-05T00:00:00.000Z"
  */
  fun toIso (date : Time) : String {
    `#{date}.toISOString()`
  }

  /* Returns the current time. */
  fun now : Time {
    `new Date()`
  }

  /* Returns the time of the begging of today. */
  fun today : Time {
    `
    (() => {
      const date = new Date()

      return new Date(Date.UTC(
        date.getUTCFullYear(),
        date.getUTCMonth(),
        date.getUTCDate()
      ))
    })()
    `
  }

  /*
  Returns a new date from the given parameters.

    Time.from(2018, 4, 5)
  */
  fun from (year : Number, month : Number, day : Number) : Time {
    `new Date(Date.UTC(#{year}, #{month} - 1, #{day}))`
  }

  /*
  Returns the day of the given time.

    (Time.from(2018, 4, 5)
    |> Time.day()) == 5
  */
  fun day (date : Time) : Number {
    `#{date}.getUTCDate()`
  }

  /*
  Returns the month of the given time.

    (Time.from(2018, 4, 5)
    |> Time.month()) == 4
  */
  fun month (date : Time) : Number {
    `(#{date}.getUTCMonth() + 1)`
  }

  /*
  Returns the year of the given time.

    (Time.from(2018, 4, 5)
    |> Time.year()) == 2018
  */
  fun year (date : Time) : Number {
    `#{date}.getUTCFullYear()`
  }

  /* Returns an array of days from the given start to given end time. */
  fun range (from : Time, to : Time) : Array(Time) {
    `
    (() => {
      const endTime = #{to}.getUTCTime();
      const currentDate = #{from};
      const dates = [];

      while (currentDate.getUTCTime() <= endTime) {
        dates.push(new Date(+currentDate))
        currentDate.setDate(currentDate.getUTCDate() + 1)
        currentDate.setHours(0, 0, 0, 0)
      }

      return dates;
    })()`
  }

  /*
  Shifts the given time using the given time span.

    (Time.from(2018, 4, 5)
    |> Time.shift(Time.Span::Days(2))
  */
  fun shift (delta : Time.Span, time : Time) : Time {
    `
    (() => {
      const time = new Date(+#{time});

      #{
        case (delta) {
          Time.Span::Milliseconds(amount) =>
            `time.setUTCMilliseconds(time.getUTCMilliseconds() + #{amount})`

          Time.Span::Seconds(amount)      =>
            `time.setUTCSeconds(time.getUTCSeconds() + #{amount})`

          Time.Span::Minutes(amount)      =>
            `time.setUTCMinutes(time.getUTCMinutes() + #{amount})`

          Time.Span::Hours(amount)        =>
            `time.setUTCHours(time.getUTCHours() + #{amount})`

          Time.Span::Days(amount)         =>
            `time.setUTCDate(time.getUTCDate() + #{amount})`

          Time.Span::Weeks(amount)        =>
            `time.setUTCDate(time.getUTCDate() + (7 * #{amount}))`

          Time.Span::Months(amount)       =>
            `time.setUTCMonth(time.getUTCMonth() + #{amount})`

          Time.Span::Years(amount)        =>
            `time.setUTCFullYear(time.getUTCFullYear() + #{amount})`
        }
      }

      return time;
    })()
    `
  }

  /* Returns the next month from the given time. */
  fun nextMonth (time : Time) : Time {
    shift(Time.Span::Months(1), time)
  }

  /* Returns the previous month from the given time. */
  fun previousMonth (time : Time) : Time {
    shift(Time.Span::Months(-1), time)
  }

  /* Returns the next week from the given time. */
  fun nextWeek (time : Time) : Time {
    shift(Time.Span::Weeks(1), time)
  }

  /* Returns the previous week from the given time. */
  fun previousWeek (time : Time) : Time {
    shift(Time.Span::Weeks(-1), time)
  }

  /* Returns the time respective to the given UNIX Timestamp (in Milliseconds) */
  fun fromUnixTimestampInMs (timestamp : Number) : Time {
    `new Date(#{timestamp})`
  }

  /* Returns the UNIX Timestamp (in Milliseconds) respective to the given time */
  fun toUnixTimestampInMs (time : Time) : Number {
    `#{time}.getTime()`
  }
}
