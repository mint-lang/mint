/*
Utility functions for working with `Time`.

_THIS MODULE IS STILL WORK IN PROGRESS_
*/
module Time {
  /*
  Tries to parse the given string as an ISO date.

    Time.fromIso("2018-04-05T00:00:00.000Z")
  */
  fromIso (raw : String) : Maybe(Time) {
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
  toIso (date : Time) : String {
    `#{date}.toISOString()`
  }

  /* Returns the current time. */
  now : Time {
    `new Date()`
  }

  /* Returns the time of the begging of today. */
  today : Time {
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
  Retruns a new UTC date from the given parameters.

    Time.from(2018, 4, 5)
  */
  from (year : Number, month : Number, day : Number) : Time {
    `new Date(Date.UTC(#{year}, #{month} - 1, #{day}))`
  }

  /*
  Returns the UTC day of the given time.

    (Time.from(2018, 4, 5)
    |> Time.day()) == 5
  */
  day (date : Time) : Number {
    `#{date}.getUTCDate()`
  }

  /*
  Returns the UTC month of the given time.

    (Time.from(2018, 4, 5)
    |> Time.month()) == 4
  */
  month (date : Time) : Number {
    `(#{date}.getUTCMonth() + 1)`
  }

  /*
  Returns the UTC year of the given time.

    (Time.from(2018, 4, 5)
    |> Time.year()) == 2018
  */
  year (date : Time) : Number {
    `#{date}.getUTCFullYear()`
  }

  /* Formats the time using the given pattern. */
  format (pattern : String, date : Time) : String {
    `DateFNS.format(#{date}, #{pattern})`
  }

  /* Returns the start of the day / month / week of the given time. */
  startOf (what : String, date : Time) : Time {
    `
    (() => {
      switch (#{what}) {
        case 'month':
          return DateFNS.startOfMonth(#{date})
        case 'week':
          return DateFNS.startOfWeek(#{date}, { weekStartsOn: 1 })
        case 'day':
          return DateFNS.startOfDay(#{date})
        default:
          return #{date}
      }
    })()
    `
  }

  /* Returns the end of the day / month / week of the given time. */
  endOf (what : String, date : Time) : Time {
    `
    (() => {
      switch (#{what}) {
        case 'month':
          return DateFNS.endOfMonth(#{date})
        case 'week':
          return DateFNS.endOfWeek(#{date}, { weekStartsOn: 1 })
        case 'day':
          return DateFNS.endOfDay(#{date})
        default:
          return #{date}
      }
    })()
    `
  }

  /* Returns an array of days from the given start to given end time. */
  range (from : Time, to : Time) : Array(Time) {
    `
    DateFNS.eachDay({
      start: #{from},
      end: #{to}
    })
    `
  }

  /* Returns the next month from the given time. */
  nextMonth (date : Time) : Time {
    `
    (() => {
      return DateFNS.addMonths(#{date}, 1)
    })()
    `
  }

  /* Returns the previous month from the given time. */
  previousMonth (date : Time) : Time {
    `
    (() => {
      return DateFNS.addMonths(#{date}, -1)
    })()
    `
  }

  /* Returns the relative time from the given times (in english). */
  relative (other : Time, now : Time) : String {
    `
    (() => {
      return DateFNS.distanceInWordsStrict(#{now}, #{other}, { addSuffix: true })
    })()
    `
  }
}
