/*
`Time` represents a point in time without a time-zone attribute.

The calendaric calculations are based on the rules of the proleptic Gregorian
calendar as specified in ISO 8601. Leap seconds are ignored.

This module uses the `Date`[1] JavaScript object under the hood. Since the
`Date` object is always in the clients time-zone, this module the UTC based
functions `getUTC*` and `setUTC*` for querying and modifying.

Things to keep in mind when working with `Time`:

- Weekdays start from 1 (1 is Monday, 7 is sunday).
- Months start from 1 (January).
- Days start from 1.

[1] https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date
*/
module Time {
  /* PARSING ----------------------------------------------------------------- */

  /*
  Tries to parse the given string as an ISO date.

    Time.parseISO("2018-04-05T00:00:00.000Z")
  */
  fun parseISO (raw : String) : Maybe(Time) {
    `
    (() => {
      try {
        return #{Maybe.Just(`new Date(#{raw})`)}
      } catch (error) {
        return #{Maybe.Nothing}
      }
    })()
    `
  }

  /* CONVERTING ------------------------------------------------------------- */

  /*
  Returns the UNIX Timestamp (in milliseconds) of the given time.

    Time.toUnix(Time.utcDate(2006, 1, 2)) == 1136160000000
  */
  fun toUnix (time : Time) : Number {
    `#{time}.getTime()`
  }

  /* CREATING ---------------------------------------------------------------- */

  /*
  Returns the time respective to the given UNIX Timestamp (in milliseconds).

    Time.unix(1136160000000) == Time.utcDate(2006, 1, 2)
  */
  fun unix (timestamp : Number) : Time {
    `new Date(#{timestamp})`
  }

  /*
  Returns a new time from the given parameters.

    Time.utc(2018, 4, 5, 12, 24, 50, 100)
  */
  fun utc (
    year : Number,
    month : Number,
    day : Number,
    hour : Number,
    minute : Number,
    second : Number,
    millisecond : Number
  ) : Time {
    `new Date(Date.UTC(#{year}, #{month} - 1, #{day}, #{hour}, #{minute}, #{second}, #{millisecond}))`
  }

  /*
  Returns a new time from the given parameters (without time parts).

    Time.utcDate(2018, 4, 5)
  */
  fun utcDate (year : Number, month : Number, day : Number) : Time {
    `new Date(Date.UTC(#{year}, #{month} - 1, #{day}))`
  }

  /*
  Returns the current time (in UTC).

    Time.now()
  */
  fun now : Time {
    `new Date()`
  }

  /*
  Returns the current time (offset by the clients time zone).

    Time.local()
  */
  fun local : Time {
    let time =
      now()

    shift(time, Time.Span.Minutes(`-#{time}.getTimezoneOffset()`))
  }

  /*
  Returns the time at the begging of today.

    Time.today()
  */
  fun today : Time {
    atBeginningOfDay(now())
  }

  /*
  Returns the time at the begging of tomorrow.

    Time.tomorrow()
  */
  fun tomorrow : Time {
    nextDay(today())
  }

  /*
  Returns the time at the begging of yesterday.

    Time.yesterday()
  */
  fun yesterday : Time {
    previousDay(today())
  }

  /* RETRIEVING TIME INFORMATION --------------------------------------------- */

  /*
  Returns the year of the given time.

    Time.year(Time.utcDate(2018, 4, 5)) == 2018
  */
  fun year (time : Time) : Number {
    `#{time}.getUTCFullYear()`
  }

  /*
  Returns the quarter of the year in which the given time occurs.

    Time.quarterOfYear(Time.utcDate(2018, 4, 5)) == 1
  */
  fun quarterOfYear (time : Time) : Number {
    `Math.trunc(#{monthNumber(time)} / 4)`
  }

  /*
  Returns the month of the given time (as a number).

    Time.monthNumber(Time.utcDate(2018, 4, 5)) == 4
  */
  fun monthNumber (time : Time) : Number {
    `#{time}.getUTCMonth() + 1`
  }

  /*
  Returns the month of the given time (as a `Month`).

    Time.month(Time.utcDate(2018, 4, 5)) == Month.April
  */
  fun month (time : Time) : Month {
    case monthNumber(time) {
      1 => Month.January
      2 => Month.February
      3 => Month.March
      4 => Month.April
      5 => Month.May
      6 => Month.June
      7 => Month.July
      8 => Month.August
      9 => Month.September
      10 => Month.October
      11 => Month.November
      => Month.December
    }
  }

  /*
  Returns the ISO calendar year and week of the given time.

  The ISO calendar year to which the week belongs is not always in the same
  as the year of the regular calendar date. The first three days of January
  sometimes belong to week 52 (or 53) of the previous year; equally the last
  three days of December sometimes are already in week 1 of the following year.

  For that reason, this method returns a tuple `year, week` consisting of the
  calendar year to which the calendar week belongs and the ordinal number of
  the week within that year.

    Time.calendarWeek(Time.utcDate(2016, 1, 1)) == {2016, 53}
  */
  fun calendarWeek (time : Time) : Tuple(Number, Number) {
    `
    (() => {
      let year =
        #{time}.getUTCFullYear();

      const day =
        #{time}.getUTCDate();

      const dayYear =
        #{dayOfYear(time)};

      const dayWeek =
        #{dayOfWeekNumber(time)};

      // The week number can be calculated as number of Mondays in the year up to the ordinal date.
      // The addition by +10 consists of +7 to start the week numbering with 1
      // instead of 0 and +3 because the first week has already started in the
      // previous year and the first Monday is actually in week 2.
      let weekNumber = Math.trunc((dayYear - dayWeek + 10) / 7);

      if (weekNumber == 0) {
        // Week number 0 means the date belongs to the last week of the previous year.
        year -= 1;

        // The week number depends on whether the previous year has 52 or 53 weeks
        // which can be determined by the day of week of January 1.
        // The year has 53 weeks if January 1 is on a Friday or the year was a leap
        // year and January 1 is on a Saturday.
        const janFirstDayOfWeek = (dayWeek - dayYear + 1) % 7;
        const isLeapYear = #{isNumberLeapYear(`year`)};

        if (janFirstDayOfWeek == 5 || (janFirstDayOfWeek == 6 && isLeapYear)) {
          weekNumber = 53;
        } else {
          weekNumber = 52;
        }
      } else if (weekNumber == 53) {
        // Week number 53 is actually week number 1 of the following year, if
        // December 31 is on a Monday, Tuesday or Wednesday.
        const dec31DayOfWeek = (dayWeek + 31 - day) % 7;

        if (dec31DayOfWeek <= 3) {
          weekNumber = 1;
          year += 1;
        }
      }

      return [year, weekNumber];
    })()
    `
  }

  /*
  Returns the day of the week of the given time (as a number from 1 to 7).

    Time.dayOfWeekNumber(Time.utcDate(2018, 4, 5)) == 4
  */
  fun dayOfWeekNumber (time : Time) : Number {
    `
    (() => {
      const dayNumber = #{time}.getUTCDay()
      return dayNumber === 0 ? 7 : dayNumber;
    })()
    `
  }

  /*
  Returns the day of week of the given time.

    Time.dayOfWeek(Time.utcDate(2018, 4, 5)) == Weekday.Thursday
  */
  fun dayOfWeek (time : Time) : Weekday {
    case dayOfWeekNumber(time) {
      1 => Weekday.Monday
      2 => Weekday.Tuesday
      3 => Weekday.Wednesday
      4 => Weekday.Thursday
      5 => Weekday.Friday
      6 => Weekday.Saturday
      => Weekday.Sunday
    }
  }

  /*
  Returns the day of month of the given time.

    Time.dayOfMonth(Time.utcDate(2018, 4, 5)) == 5
  */
  fun dayOfMonth (time : Time) : Number {
    `#{time}.getUTCDate()`
  }

  /*
  Returns the day of the year of the given time.

    Time.dayOfYear(Time.utcDate(2018, 4, 5)) == 95
  */
  fun dayOfYear (time : Time) : Number {
    `
    (() => {
      const first =
        Date.UTC(#{time}.getUTCFullYear(), 0, 1)

      const current =
        Date.UTC(#{time}.getUTCFullYear(), #{time}.getUTCMonth(), #{time}.getUTCDate())

      return ((current - first) / 24 / 60 / 60 / 1000) + 1
    })()
    `
  }

  /*
  Returns the hour of the given time.

    Time.hour(Time.utc(2018, 4, 5, 10, 25, 30, 40) == 10
  */
  fun hour (time : Time) : Number {
    `#{time}.getUTCHours()`
  }

  /*
  Returns the minute of the given time.

    Time.minute(Time.utc(2018, 4, 5, 10, 25, 30, 40)) == 25
  */
  fun minute (time : Time) : Number {
    `#{time}.getUTCMinutes()`
  }

  /*
  Returns the second of the given time.

    Time.second(Time.utc(2018, 4, 5, 10, 25, 30, 40)) == 30
  */
  fun second (time : Time) : Number {
    `#{time}.getUTCSeconds()`
  }

  /*
  Returns the millisecond of the given time.

    Time.millisecond(Time.utc(2018, 4, 5, 10, 25, 30, 40)) == 40
  */
  fun millisecond (time : Time) : Number {
    `#{time}.getUTCMilliseconds()`
  }

  /*
  Returns if the year of the given time is a leap year or not.

    Time.isLeapYear(Time.utcDate(2011,1,1)) == false
    Time.isLeapYear(Time.utcDate(2012,1,1)) == true
  */
  fun isLeapYear (time : Time) : Bool {
    isNumberLeapYear(year(time))
  }

  /*
  Returns if the given number (year) is a leap year or not.

    Time.isNumberLeapYear(2020) == true
    Time.isNumberLeapYear(2021) == false
  */
  fun isNumberLeapYear (year : Number) : Bool {
    (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0)
  }

  /* MANIPULATION ------------------------------------------------------------ */

  /*
  Shifts the given time using the given time span.

    Time.shift(Time.utcDate(2018, 4, 5), Time.Span.Days(2)) ==
      Time.utcDate(2018, 4, 7)
  */
  fun shift (time : Time, delta : Time.Span) : Time {
    `
    (() => {
      const time = new Date(+#{time});

      #{
        case (delta) {
          Time.Span.Milliseconds(amount) =>
            `time.setUTCMilliseconds(time.getUTCMilliseconds() + #{amount})`

          Time.Span.Seconds(amount) =>
            `time.setUTCSeconds(time.getUTCSeconds() + #{amount})`

          Time.Span.Minutes(amount)      =>
            `time.setUTCMinutes(time.getUTCMinutes() + #{amount})`

          Time.Span.Hours(amount)        =>
            `time.setUTCHours(time.getUTCHours() + #{amount})`

          Time.Span.Days(amount)         =>
            `time.setUTCDate(time.getUTCDate() + #{amount})`

          Time.Span.Weeks(amount)        =>
            `time.setUTCDate(time.getUTCDate() + (7 * #{amount}))`

          Time.Span.Months(amount)       =>
            `time.setUTCMonth(time.getUTCMonth() + #{amount})`

          Time.Span.Years(amount)        =>
            `time.setUTCFullYear(time.getUTCFullYear() + #{amount})`
        }
      }

      return time;
    })()
    `
  }

  /*
  Returns a new time which is at the beginning of the same year
  as the given time.

    Time.atBeginningOfYear(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 1, 1)
  */
  fun atBeginningOfYear (time : Time) : Time {
    `
    (() => {
      const time = new Date(+#{time});
      time.setUTCMonth(0, 1);
      time.setUTCHours(0, 0, 0, 0);
      return time;
    })()
    `
  }

  /*
  Returns a new time which is at the beginning of the same month
  as the given time.

    Time.atBeginningOfMonth(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 1)
  */
  fun atBeginningOfMonth (time : Time) : Time {
    `
    (() => {
      const time = new Date(+#{time});
      time.setUTCDate(1);
      time.setUTCHours(0, 0, 0, 0);
      return time;
    })()
    `
  }

  /*
  Returns a new time which is at the beginning of the same week
  as the given time.

    Time.atBeginningOfWeek(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 15)
  */
  fun atBeginningOfWeek (time : Time) : Time {
    let day =
      dayOfWeekNumber(time)

    shift(time, Time.Span.Days(-(day - 1)))
  }

  /*
  Returns a new time which is at the beginning of the same day
  as the given time.

    Time.atBeginningOfDay(Time.utc(2017, 5, 20, 10, 34, 22, 40)) ==
      Time.utc(2017, 5, 20, 0, 0, 0, 0)
  */
  fun atBeginningOfDay (time : Time) : Time {
    `
    (() => {
      const time = new Date(+#{time});
      time.setUTCHours(0, 0, 0, 0);
      return time;
    })()
    `
  }

  /*
  Returns a new time which is at the end of the same year
  as the given time.

    Time.atEndOfYear(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 12, 31)
  */
  fun atEndOfYear (time : Time) : Time {
    `
    (() => {
      const time = new Date(+#{time});
      time.setUTCMonth(12, 1);         // Set it to next January 1st
      time.setUTCHours(0, 0, 0, -1);   // Subtract 1 millisecond
      return time;
    })()
    `
  }

  /*
  Returns a new time which is at the end of the same month
  as the given time.

    Time.atEndOfMonth(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 31)
  */
  fun atEndOfMonth (time : Time) : Time {
    `
    (() => {
      const time = new Date(+#{time});
      const month = time.getUTCMonth();
      time.setUTCMonth(month + 1, 1);   // Set it to 1st of the next month
      time.setUTCHours(0, 0, 0, -1);    // Subtract 1 millisecond
      return time;
    })()
    `
  }

  /*
  Returns a new time which is at the beginning of the same week
  as the given time.

    Time.atEndOfWeek(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 1)
  */
  fun atEndOfWeek (time : Time) : Time {
    time
    |> shift(Time.Span.Days(7 - dayOfWeekNumber(time)))
    |> atEndOfDay
  }

  /*
  Returns a new time which is at the beginning of the same day
  as the given time.

    Time.atEndOfDay(Time.utc(2017, 5, 20, 10, 34, 22, 40)) ==
      Time.utc(2017, 5, 20, 0, 0, 0, 0)
  */
  fun atEndOfDay (time : Time) : Time {
    `
    (() => {
      const time = new Date(+#{time});
      const date = time.getUTCDate();
      time.setUTCDate(date + 1);      // Set it to the beginning of the next day
      time.setUTCHours(0, 0, 0, -1);  // Subtract 1 millisecond
      return time;
    })()
    `
  }

  /*
  Returns a new time which is a month later than the the given time.

    Time.nextMonth(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 6, 20)
  */
  fun nextMonth (time : Time) : Time {
    shift(time, Time.Span.Months(1))
  }

  /*
  Returns a new time which is a month sooner than the the given time.

    Time.previousMonth(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 4, 20)
  */
  fun previousMonth (time : Time) : Time {
    shift(time, Time.Span.Months(-1))
  }

  /*
  Returns a new time which is a week later than the the given time.

    Time.nextWeek(Time.utcDate(2017, 5, 10)) == Time.utcDate(2017, 5, 17)
  */
  fun nextWeek (time : Time) : Time {
    shift(time, Time.Span.Weeks(1))
  }

  /*
  Returns a new time which is a week sooner than the the given time.

    Time.previousWeek(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 13)
  */
  fun previousWeek (time : Time) : Time {
    shift(time, Time.Span.Weeks(-1))
  }

  /*
  Returns a new time which is a day later than the the given time.

    Time.nextDay(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 21)
  */
  fun nextDay (time : Time) : Time {
    shift(time, Time.Span.Days(1))
  }

  /*
  Returns a new time which is a day sooner than the the given time.

    Time.previousDay(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 19)
  */
  fun previousDay (time : Time) : Time {
    shift(time, Time.Span.Days(-1))
  }

  /* UTILITIES -------------------------------------------------------------- */

  /*
  Returns an array of days from the given start to given end time (inclusive).

    Time.range(Time.utcDate(2006, 4, 1), Time.utcDate(2006, 4, 4)) == [
      Time.utcDate(2006, 4, 1),
      Time.utcDate(2006, 4, 2),
      Time.utcDate(2006, 4, 3),
      Time.utcDate(2006, 4, 4)
    ]
  */
  fun range (from : Time, to : Time) : Array(Time) {
    `
    (() => {
      const currentDate = #{atBeginningOfDay(from)};
      const endTime = #{atEndOfDay(to)}.getTime();
      const dates = [];

      while (currentDate.getTime() <= endTime) {
        dates.push(new Date(+currentDate))
        currentDate.setUTCDate(currentDate.getUTCDate() + 1)
        currentDate.setUTCHours(0, 0, 0, 0)
      }

      return dates;
    })()`
  }

  /*
  Converts the given time zone, since not all browsers support time zone
  conversion this function can fail.

    Time.inZone("America/New_York", Time.utc(2019, 1, 1, 7, 12, 35, 200)) ==
      Maybe.Just(Time.utc(2019, 1, 1, 2, 12, 35, 200))
  */
  fun inZone (timeZone : String, time : Time) : Maybe(Time) {
    `
    (() => {
      try {
        const time = new Date(#{time}.toLocaleString("en-US", { timeZone: #{timeZone} }));

        // Correct the millisecond since the en-US local string doesn't contain that.
        time.setUTCMilliseconds(#{time}.getUTCMilliseconds())

        // Shift the resulting time by the local time-zone offset.
        time.setUTCMinutes(time.getUTCMinutes() - time.getTimezoneOffset())

        return #{Maybe.Just(`time`)};
      } catch {
        return #{Maybe.Nothing}
      }
    })()
    `
  }
}
