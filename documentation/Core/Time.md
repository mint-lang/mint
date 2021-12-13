# Time

The `Time` related functionality resides in the `Time` module.

`Time` is just a specific point in time without attached time-zone information, so any `Time` is considered to be in UTC.

## Telling the Time

There are multiple ways to retrieve a `Time` representing the current time:

```
Time.now()   // returns the current time in UTC
Time.local() // returns the current time in the clients time-zone
```

It is generally recommended to keep instances in UTC and only apply a local time-zone when formatting for user display, unless the domain logic requires having a specific time-zone (for example for calendaric operations).

There are some handy functions for getting time (at the beginning of the day):

```
Time.today()     // returns the time for the beginning of today (UTC)
Time.tomorrow()  // returns the time for the beginning of tomorrow (UTC)
Time.yesterday() // returns the time for the beginning of yesterday (UTC)
```

## Creating a Specific Instant

A `Time` representing a specific instant can be created by `Time.utc` or `Time.utcDate` methods:

```
time =
  Time.utc(2016, 2, 15, 10, 20, 30, 200)

date =
  Time.utcDate(2016, 2, 15)
```

## Retrieving Time Information

Each `Time` instance allows querying it's calendar data:

```
time =
  Time.utc(2016, 2, 15, 10, 20, 30, 200)

Time.year(time)            // 2016
Time.quarterOfYear(time)   // 1
Time.monthNumber(time)     // 2
Time.month(time)           // Month::February
Time.calendarWeek(time)    // TODO: {2016,}
Time.dayOfWeekNumber(time) // 1
Time.dayOfWeek(time)       // Weekday::Monday
Time.dayOfMonth(time)      // 15
Time.dayOfYear(time)       // TODO:
Time.hour(time)            // 10
Time.minute(time)          // 20
Time.second(time)          // 30
Time.millisecond(time)     // 200
Time.isLeapYear(time)      // true
```

## Manipulating Time

The main way to manipulate a `Time` is to use the `Time.shift` function:

```
time =
  Time.utc(2016, 2, 15, 10, 20, 30, 200)

Time.shift(Time.Span::Days(2), time) == Time.utc(2016, 2, 17, 10, 20, 30, 200)
Time.shift(Time.Span::Days(-2), time) == Time.utc(2016, 2, 13, 10, 20, 30, 200)
```

Where `Time.Span` is an enum:

```
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
```

There are some handy functions for manipulating time that use the function above:

```
Time.atBeginningOfYear(time)
Time.atBeginningOfMonth(time)
Time.atBeginningOfWeek(time)
Time.atBeginningOfDay()time
Time.atEndOfYear(time)
Time.atEndOfMonth(time)
Time.atEndOfWeek(time)
Time.atEndOfDay(time)
Time.nextMonth(time)
Time.previousMonth(time)
Time.nextWeek(time)
Time.previousWeek(time)
Time.nextDay(time)
Time.previousDay(time)
```

## Utilities

To get a range times between two times you can use the `Time.range` function:

```
Time.range(Time.utcDate(2006, 4, 1), Time.utcDate(2006, 4, 4)) == [
  Time.utcDate(2006, 4, 1),
  Time.utcDate(2006, 4, 2),
  Time.utcDate(2006, 4, 3),
  Time.utcDate(2006, 4, 4)
]
```

## Time Zones

To get a `Time` which is in a different time-zone you can use the `Time.inZone` function, which will return the given `Time` shifted by the offset of the given time-zone relative to UTC.

```
Time.inZone("America/New_York", Time.utc(2019, 1, 1, 7, 12, 35, 200)) ==
  Maybe::Just(Time.utc(2019, 1, 1, 2, 12, 35, 200))
```

Please not that this function returns `Maybe(Time)` because:

- it's using an underlying JavaScript function if which might not be available (old browser for example)
- the given time-zone maybe be invalid (since it's just a `String`)

## Formatting Time

You can format a `Time` using the `Time.format` function:

```
Time.format(
  Time.Format:ENGLISH,
  "%Y-%m-%dT%H:%M:%S.%LZ",
  Time.utcDate(2018, 4, 5)) == "2018-04-05T00:00:00.000Z"
```

The following tokens can be used in the pattern:

  - %a: short day name (Sun, Mon, Tue, ...)
  - %^a: short day name, upcase (SUN, MON, TUE, ...)
  - %A: day name (Sunday, Monday, Tuesday, ...)
  - %^A: day name, upcase (SUNDAY, MONDAY, TUESDAY, ...)
  - %b: short month name (Jan, Feb, Mar, ...)
  - %^b: short month name, upcase (JAN, FEB, MAR, ...)
  - %B: month name (January, February, March, ...)
  - %^B: month name, upcase (JANUARY, FEBRUARY, MARCH, ...)
  - %c: date and time (Tue Apr 5 10:26:19 2016)
  - %C: year divided by 100
  - %d: day of month, zero padded (01, 02, ...)
  - %-d: day of month (1, 2, ..., 31)
  - %D: date (04/05/16)
  - %e: day of month, blank padded (" 1", " 2", ..., "10", "11", ...)
  - %F: ISO 8601 date (2016-04-05)
  - %g: week-based calendar year modulo 100 (00..99)
  - %G: week-based calendar year (0001..9999)
  - %h: (same as %b) short month name (Jan, Feb, Mar, ...)
  - %H: hour of the day, 24-hour clock, zero padded (00, 01, ..., 24)
  - %I: hour of the day, 12-hour clock, zero padded (00, 01, ..., 12)
  - %j: day of year, zero padded (001, 002, ..., 365)
  - %k: hour of the day, 24-hour clock, blank padded (" 0", " 1", ..., "24")
  - %l: hour of the day, 12-hour clock, blank padded (" 0", " 1", ..., "12")
  - %L: milliseconds, zero padded (000, 001, ..., 999)
  - %m: month number, zero padded (01, 02, ..., 12)
  - %_m: month number, blank padded (" 1", " 2", ..., "12")
  - %-m: month number (1, 2, ..., 12)
  - %M: minute, zero padded (00, 01, 02, ..., 59)
  - %p: am-pm (lowercase)
  - %P: AM-PM (uppercase)
  - %r: 12-hour time (03:04:05 AM)
  - %R: 24-hour time (13:04)
  - %s: seconds since unix epoch
  - %S: seconds, zero padded (00, 01, ..., 59)
  - %T: 24-hour time (13:04:05)
  - %u: day of week (Monday is 1, 1..7)
  - %V: ISO calendar week number of the week-based year (01..53)
  - %w: day of week (Sunday is 0, 0..6)
  - %x: (same as %D) date (04/05/16)
  - %X: (same as %T) 24-hour time (13:04:05)
  - %y: year modulo 100
  - %Y: year, zero padded

There are no tokens for time-zones because `Time` doesn't have an associated time-zone on it.
