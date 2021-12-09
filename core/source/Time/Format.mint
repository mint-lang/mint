module Time {
  fun format (
    language : Time.Format.Language,
    pattern : String,
    time : Time
  ) : String {
    `
    (() => {
      let result = "";
      let index = 0;
      let char;

      while (char = #{pattern}[index]) {
        if (char == "%") {
          const nextTwoChars =
            #{pattern}.slice(index + 1, index + 3);

          let converted =
            #{formatToken(language, `nextTwoChars`, time)};

          if (converted !== nextTwoChars) {
            result += converted
            index += 3;
            continue;
          } else {
            const nextChar =
              #{pattern}[index + 1];

            const converted =
              #{formatToken(language, `nextChar`, time)};

            if (converted !== nextChar) {
              result += converted;
              index += 2;
              continue;
            }
          }
        }

        result += char;
        index++;
      }

      return result;
    })()
    `
  }

  /*
  Formats the given time to the ISO format.

    Time.formatISO(Tome.today()) == "2018-04-05T00:00:00.000Z"
  */
  fun formatISO (time : Time) : String {
    /* TODO: Time zone. */
    format(Time.Format:ENGLISH, "%Y-%m-%dT%H:%M:%S.000Z", time)
  }

  fun formatToken (
    language : Time.Format.Language,
    token : String,
    time : Time
  ) : String {
    case (token) {
      /* short day name (Sun, Mon, Tue, ...) */
      "a" =>
        time
        |> dayOfWeek
        |> language.toWeekdayAbbreviation

      /* short day name, upcase (SUN, MON, TUE, ...) */
      "^a" =>
        time
        |> dayOfWeek
        |> language.toWeekdayAbbreviation
        |> String.toUpperCase

      /* day name (Sunday, Monday, Tuesday, ...) */
      "A" =>
        time
        |> dayOfWeek
        |> language.toWeekdayName

      /* day name, upcase (SUNDAY, MONDAY, TUESDAY, ...) */
      "^A" =>
        time
        |> dayOfWeek
        |> language.toWeekdayName
        |> String.toUpperCase

      /* short month name (Jan, Feb, Mar, ...) */
      "b" =>
        time
        |> month
        |> language.toMonthAbbreviation

      /* short month name, upcase (JAN, FEB, MAR, ...) */
      "^b" =>
        time
        |> month
        |> language.toMonthAbbreviation
        |> String.toUpperCase

      /* month name (January, February, March, ...) */
      "B" =>
        time
        |> month
        |> language.toMonthName

      /* month name, upcase (JANUARY, FEBRUARY, MARCH, ...) */
      "^B" =>
        time
        |> month
        |> language.toMonthName
        |> String.toUpperCase

      /* date and time (Tue Apr 5 10:26:19 2016) */
      "c" =>
        format(language, "%a %b %-d %H:%M:%S %Y", time)

      /* year divided by 100. */
      "C" =>
        year(time) / 100
        |> Number.toString

      /* day of month, zero padded (01, 02, ...) */
      "d" =>
        time
        |> dayOfMonth()
        |> Number.toString
        |> String.padLeft("0", 2)

      /* day of month (1, 2, ..., 31) */
      "-d" =>
        time
        |> dayOfMonth()
        |> Number.toString

      /* date (04/05/16) */
      "D" =>
        format(language, "%m/%d/%Y", time)

      /* day of month, blank padded (" 1", " 2", ..., "10", "11", ...) */
      "e" =>
        time
        |> dayOfMonth()
        |> Number.toString
        |> String.padLeft(" ", 2)

      /* ISO 8601 date (2016-04-05) */
      "F" =>
        format(language, "%Y-%m-%d", time)

      /* week-based calendar year modulo 100 (00..99) */
      "g" =>
        (calendarWeek(time)[0] % 100)
        |> Number.toString
        |> String.padLeft("0", 2)

      /* week-based calendar year (0001..9999) */
      "G" =>
        calendarWeek(time)[0]
        |> Number.toString
        |> String.padLeft("0", 4)

      /* hour of the day, 24-hour clock, zero padded (00, 01, ..., 24) */
      "H" =>
        time
        |> hour
        |> Number.toString()
        |> String.padLeft("0", 2)

      /* hour of the day, 12-hour clock, zero padded (00, 01, ..., 12) */
      "I" =>
        (hour(time) - 12)
        |> Math.abs
        |> Number.toString()
        |> String.padLeft("0", 2)

      /* day of year, zero padded (001, 002, ..., 365) */
      "j" =>
        time
        |> dayOfYear
        |> Number.toString
        |> String.padLeft("0", 3)

      /* hour of the day, 24-hour clock, blank padded (" 0", " 1", ..., "24") */
      "k" =>
        time
        |> hour
        |> Number.toString()
        |> String.padLeft(" ", 2)

      /* hour of the day, 12-hour clock, blank padded (" 0", " 1", ..., "12") */
      "l" =>
        (hour(time) - 12)
        |> Math.abs
        |> Number.toString()
        |> String.padLeft(" ", 2)

      /* milliseconds, zero padded (000, 001, ..., 999) */
      "L" =>
        time
        |> millisecond
        |> Number.toString()
        |> String.padLeft(" ", 4)

      /* month number, zero padded (01, 02, ..., 12) */
      "m" =>
        time
        |> monthNumber()
        |> Number.toString
        |> String.padLeft("0", 2)

      /* month number, blank padded (" 1", " 2", ..., "12") */
      "_m" =>
        time
        |> monthNumber()
        |> Number.toString
        |> String.padLeft(" ", 2)

      /* month number (1, 2, ..., 12) */
      "-m" =>
        time
        |> monthNumber
        |> Number.toString

      /* minute, zero padded (00, 01, 02, ..., 59) */
      "M" =>
        time
        |> minute
        |> Number.toString()
        |> String.padLeft("0", 2)

      /* am-pm (lowercase) */
      "p" =>
        time
        |> hour()
        |> language.amPm
        |> String.toLowerCase

      /* AM-PM (uppercase) */
      "P" =>
        time
        |> hour
        |> language.amPm
        |> String.toUpperCase

      /* 12-hour time (03:04:05 AM) */
      "r" =>
        format(language, "%I:%M:%S %P", time)

      /* 24-hour time (13:04) */
      "R" =>
        format(language, "%H:%M", time)

      /* seconds since unix epoch */
      "s" =>
        time
        |> Time.toUnix
        |> Number.toString

      /* seconds, zero padded (00, 01, ..., 59) */
      "S" =>
        time
        |> second
        |> Number.toString
        |> String.padLeft("0", 2)

      /* 24-hour time (13:04:05) */
      "T" =>
        format(language, "%H:%M:%S", time)

      /* day of week (Monday is 1, 1..7) */
      "u" =>
        time
        |> dayOfWeekNumber
        |> Number.toString

      /* ISO calendar week number of the week-based year (01..53) */
      "V" =>
        calendarWeek(time)[1]
        |> Number.toString
        |> String.padLeft("0", 2)

      /* day of week (Sunday is 0, 0..6) */
      "w" =>
        try {
          number =
            dayOfWeekNumber(time)

          if (number == 7) {
            0
          } else {
            number
          }
          |> Number.toString
        }

      /* (same as %D) date (04/05/16) */
      "x" =>
        format(language, "%m/%d/%Y", time)

      /* (same as %T) 24-hour time (13:04:05) */
      "X" =>
        format(language, "%H:%M:%S", time)

      /* year modulo 100. */
      "y" =>
        year(time) % 100
        |> Number.toString

      /* year, zero padded */
      "Y" =>
        time
        |> year
        |> Number.toString
        |> String.padLeft("0", 4)

      =>
        token
    }
  }
}
