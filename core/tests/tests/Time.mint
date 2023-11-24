suite "Time equality" {
  test "returns true if the two times are equal" {
    Time.today() == Time.today()
  }

  test "returns false if the two times are not equal" {
    Time.now() != Time.today()
  }
}

suite "Time.parseISO" {
  test "returns the time from an ISO string" {
    (Time.today()
    |> Time.formatISO()
    |> Time.parseISO()
    |> Maybe.withLazyDefault(() { Time.now() })) == Time.today()
  }
}

suite "Time.toUnix" {
  test "returns the UNIX Timestamp (in Milliseconds)" {
    Time.toUnix(Time.utcDate(2006, 1, 2)) == 1136160000000
  }
}

suite "Time.unix" {
  test "returns the UTC time from the given UNIX Timestamp (in Milliseconds)" {
    Time.unix(1136160000000) == Time.utcDate(2006, 1, 2)
  }
}

suite "Time.utc" {
  test "returns the UTC time with the given parameters" {
    (Time.utc(2018, 4, 5, 16, 51, 23, 320)
    |> Time.formatISO()) == "2018-04-05T16:51:23.320Z"
  }
}

suite "Time.utcDate" {
  test "returns the UTC time with the given parameters" {
    (Time.utcDate(2018, 4, 5)
    |> Time.formatISO()) == "2018-04-05T00:00:00.000Z"
  }
}

suite "Time.today" {
  test "returns the time as it is today" {
    Time.today() == Time.today()
  }
}

suite "Time.tomorrow" {
  test "returns the time as it is tomorrow" {
    Time.tomorrow() == Time.tomorrow()
  }
}

suite "Time.yesterday" {
  test "returns the time as it is yesterday" {
    Time.yesterday() == Time.yesterday()
  }
}

suite "Time.year" {
  test "returns the year of the time" {
    Time.year(Time.utcDate(2018, 4, 5)) == 2018
  }
}

suite "Time.quarterOfYear" {
  test "returns in which quarterOfYear of the year the given time is" {
    Time.quarterOfYear(Time.utcDate(2018, 4, 5)) == 1
  }
}

suite "Time.monthNumber" {
  test "returns the month of the time (as a number)" {
    Time.monthNumber(Time.utcDate(2018, 4, 5)) == 4
  }
}

suite "Time.month" {
  test "returns the month of the time" {
    Time.month(Time.utcDate(2018, 4, 5)) == Month.April
  }
}

suite "Time.calendarWeek" {
  const TEST_DATA =
    [
      {{1981, 1, 1}, {1981, 1, 4}},
      {{1982, 1, 1}, {1981, 53, 5}},
      {{1983, 1, 1}, {1982, 52, 6}},
      {{1984, 1, 1}, {1983, 52, 7}},
      {{1985, 1, 1}, {1985, 1, 2}},
      {{1985, 4, 12}, {1985, 15, 5}},
      {{1986, 1, 1}, {1986, 1, 3}},
      {{1987, 1, 1}, {1987, 1, 4}},
      {{1988, 1, 1}, {1987, 53, 5}},
      {{1989, 1, 1}, {1988, 52, 7}},
      {{1990, 1, 1}, {1990, 1, 1}},
      {{1991, 1, 1}, {1991, 1, 2}},
      {{1992, 1, 1}, {1992, 1, 3}},
      {{1993, 1, 1}, {1992, 53, 5}},
      {{1994, 1, 1}, {1993, 52, 6}},
      {{1995, 1, 2}, {1995, 1, 1}},
      {{1996, 1, 1}, {1996, 1, 1}},
      {{1996, 1, 7}, {1996, 1, 7}},
      {{1996, 1, 8}, {1996, 2, 1}},
      {{1997, 1, 1}, {1997, 1, 3}},
      {{1998, 1, 1}, {1998, 1, 4}},
      {{1999, 1, 1}, {1998, 53, 5}},
      {{2000, 1, 1}, {1999, 52, 6}},
      {{2001, 1, 1}, {2001, 1, 1}},
      {{2002, 1, 1}, {2002, 1, 2}},
      {{2003, 1, 1}, {2003, 1, 3}},
      {{2004, 1, 1}, {2004, 1, 4}},
      {{2005, 1, 1}, {2004, 53, 6}},
      {{2006, 1, 1}, {2005, 52, 7}},
      {{2007, 1, 1}, {2007, 1, 1}},
      {{2008, 1, 1}, {2008, 1, 2}},
      {{2009, 1, 1}, {2009, 1, 4}},
      {{2010, 1, 1}, {2009, 53, 5}},
      {{2010, 1, 1}, {2009, 53, 5}},
      {{2011, 1, 1}, {2010, 52, 6}},
      {{2011, 1, 2}, {2010, 52, 7}},
      {{2011, 1, 3}, {2011, 1, 1}},
      {{2011, 1, 4}, {2011, 1, 2}},
      {{2011, 1, 5}, {2011, 1, 3}},
      {{2011, 1, 6}, {2011, 1, 4}},
      {{2011, 1, 7}, {2011, 1, 5}},
      {{2011, 1, 8}, {2011, 1, 6}},
      {{2011, 1, 9}, {2011, 1, 7}},
      {{2011, 1, 10}, {2011, 2, 1}},
      {{2011, 1, 11}, {2011, 2, 2}},
      {{2011, 6, 12}, {2011, 23, 7}},
      {{2011, 6, 13}, {2011, 24, 1}},
      {{2011, 12, 25}, {2011, 51, 7}},
      {{2011, 12, 26}, {2011, 52, 1}},
      {{2011, 12, 27}, {2011, 52, 2}},
      {{2011, 12, 28}, {2011, 52, 3}},
      {{2011, 12, 29}, {2011, 52, 4}},
      {{2011, 12, 30}, {2011, 52, 5}},
      {{2011, 12, 31}, {2011, 52, 6}},
      {{1995, 1, 1}, {1994, 52, 7}},
      {{2012, 1, 1}, {2011, 52, 7}},
      {{2012, 1, 2}, {2012, 1, 1}},
      {{2012, 1, 8}, {2012, 1, 7}},
      {{2012, 1, 9}, {2012, 2, 1}},
      {{2012, 12, 23}, {2012, 51, 7}},
      {{2012, 12, 24}, {2012, 52, 1}},
      {{2012, 12, 30}, {2012, 52, 7}},
      {{2012, 12, 31}, {2013, 1, 1}},
      {{2013, 1, 1}, {2013, 1, 2}},
      {{2013, 1, 6}, {2013, 1, 7}},
      {{2013, 1, 7}, {2013, 2, 1}},
      {{2013, 12, 22}, {2013, 51, 7}},
      {{2013, 12, 23}, {2013, 52, 1}},
      {{2013, 12, 29}, {2013, 52, 7}},
      {{2013, 12, 30}, {2014, 1, 1}},
      {{2014, 1, 1}, {2014, 1, 3}},
      {{2014, 1, 5}, {2014, 1, 7}},
      {{2014, 1, 6}, {2014, 2, 1}},
      {{2015, 1, 1}, {2015, 1, 4}},
      {{2016, 1, 1}, {2015, 53, 5}},
      {{2017, 1, 1}, {2016, 52, 7}},
      {{2018, 1, 1}, {2018, 1, 1}},
      {{2019, 1, 1}, {2019, 1, 2}},
      {{2020, 1, 1}, {2020, 1, 3}},
      {{2021, 1, 1}, {2020, 53, 5}},
      {{2022, 1, 1}, {2021, 52, 6}},
      {{2023, 1, 1}, {2022, 52, 7}},
      {{2024, 1, 1}, {2024, 1, 1}},
      {{2025, 1, 1}, {2025, 1, 3}},
      {{2026, 1, 1}, {2026, 1, 4}},
      {{2027, 1, 1}, {2026, 53, 5}},
      {{2028, 1, 1}, {2027, 52, 6}},
      {{2029, 1, 1}, {2029, 1, 1}},
      {{2030, 1, 1}, {2030, 1, 2}},
      {{2031, 1, 1}, {2031, 1, 3}},
      {{2032, 1, 1}, {2032, 1, 4}},
      {{2033, 1, 1}, {2032, 53, 6}},
      {{2034, 1, 1}, {2033, 52, 7}},
      {{2035, 1, 1}, {2035, 1, 1}},
      {{2036, 1, 1}, {2036, 1, 2}},
      {{2037, 1, 1}, {2037, 1, 4}},
      {{2038, 1, 1}, {2037, 53, 5}},
      {{2039, 1, 1}, {2038, 52, 6}},
      {{2040, 1, 1}, {2039, 52, 7}}
    ]

  test "returns proper calendar week" {
    let expected =
      for item of TEST_DATA {
        ({item[1][0], item[1][1]})
      }

    let actual =
      for item of TEST_DATA {
        Time.utcDate(item[0][0], item[0][1], item[0][2])
        |> Time.calendarWeek
      }

    expected == actual
  }
}

suite "Time.dayOfWeekNumber" {
  test "returns the day of the week of the given time" {
    Time.dayOfWeekNumber(Time.utcDate(2018, 4, 5)) == 4
  }
}

suite "Time.dayOfWeek" {
  test "returns the day of the week of the given time (as a number)" {
    Time.dayOfWeek(Time.utcDate(2018, 4, 5)) == Weekday.Thursday
  }
}

suite "Time.dayOfMonth" {
  test "returns the day of the month of the time" {
    Time.dayOfMonth(Time.utcDate(2018, 4, 5)) == 5
  }
}

suite "Time.dayOfYear" {
  test "returns the day of the year of the time" {
    Time.dayOfYear(Time.utcDate(2018, 4, 5)) == 95
  }
}

suite "Time.hour" {
  test "returns the hour of the given time" {
    Time.hour(Time.utc(2018, 4, 5, 10, 25, 30, 40)) == 10
  }
}

suite "Time.minute" {
  test "returns the minute of the given time" {
    Time.minute(Time.utc(2018, 4, 5, 10, 25, 30, 40)) == 25
  }
}

suite "Time.second" {
  test "returns the second of the given time" {
    Time.second(Time.utc(2018, 4, 5, 10, 25, 30, 40)) == 30
  }
}

suite "Time.millisecond" {
  test "returns the millisecond of the given time" {
    Time.millisecond(Time.utc(2018, 4, 5, 10, 25, 30, 40)) == 40
  }
}

suite "Time.isLeapYear" {
  test "returns true if time is in a leap year" {
    Time.isLeapYear(Time.utcDate(2012, 1, 1)) == true
  }

  test "returns false if time is not in a leap year" {
    Time.isLeapYear(Time.utcDate(2011, 1, 1)) == false
  }
}

suite "Time.isNumberLeapYear" {
  test "returns true for leap year" {
    Time.isNumberLeapYear(2020) == true
  }

  test "returns false for not leap year" {
    Time.isNumberLeapYear(2021) == false
  }
}

suite "Time.shift" {
  const BASE_TIME = Time.utc(2018, 4, 5, 14, 42, 54, 20)

  const TEST_DATA =
    [
      {Time.Span.Milliseconds(0), Time.utc(2018, 4, 5, 14, 42, 54, 20)},
      {Time.Span.Milliseconds(2), Time.utc(2018, 4, 5, 14, 42, 54, 22)},
      {Time.Span.Milliseconds(-2), Time.utc(2018, 4, 5, 14, 42, 54, 18)},
      {Time.Span.Seconds(0), Time.utc(2018, 4, 5, 14, 42, 54, 20)},
      {Time.Span.Seconds(2), Time.utc(2018, 4, 5, 14, 42, 56, 20)},
      {Time.Span.Seconds(-2), Time.utc(2018, 4, 5, 14, 42, 52, 20)},
      {Time.Span.Minutes(0), Time.utc(2018, 4, 5, 14, 42, 54, 20)},
      {Time.Span.Minutes(2), Time.utc(2018, 4, 5, 14, 44, 54, 20)},
      {Time.Span.Minutes(-2), Time.utc(2018, 4, 5, 14, 40, 54, 20)},
      {Time.Span.Hours(0), Time.utc(2018, 4, 5, 14, 42, 54, 20)},
      {Time.Span.Hours(2), Time.utc(2018, 4, 5, 16, 42, 54, 20)},
      {Time.Span.Hours(-2), Time.utc(2018, 4, 5, 12, 42, 54, 20)},
      {Time.Span.Days(0), Time.utc(2018, 4, 5, 14, 42, 54, 20)},
      {Time.Span.Days(2), Time.utc(2018, 4, 7, 14, 42, 54, 20)},
      {Time.Span.Days(-2), Time.utc(2018, 4, 3, 14, 42, 54, 20)},
      {Time.Span.Weeks(0), Time.utc(2018, 4, 5, 14, 42, 54, 20)},
      {Time.Span.Weeks(2), Time.utc(2018, 4, 19, 14, 42, 54, 20)},
      {Time.Span.Weeks(-2), Time.utc(2018, 3, 22, 14, 42, 54, 20)},
      {Time.Span.Months(0), Time.utc(2018, 4, 5, 14, 42, 54, 20)},
      {Time.Span.Months(2), Time.utc(2018, 6, 5, 14, 42, 54, 20)},
      {Time.Span.Months(-2), Time.utc(2018, 2, 5, 14, 42, 54, 20)},
      {Time.Span.Years(0), Time.utc(2018, 4, 5, 14, 42, 54, 20)},
      {Time.Span.Years(2), Time.utc(2020, 4, 5, 14, 42, 54, 20)},
      {Time.Span.Years(-2), Time.utc(2016, 4, 5, 14, 42, 54, 20)}
    ]

  test "shifts the given time with the given span" {
    let expected =
      for item of TEST_DATA {
        item[1]
      }

    let actual =
      for item of TEST_DATA {
        Time.shift(BASE_TIME, item[0])
      }

    expected == actual
  }
}

suite "Time.atBeginningOfYear" {
  test "returns a time which is at the beginning of the same year as the given time" {
    Time.atBeginningOfYear(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 1, 1)
  }
}

suite "Time.atBeginningOfMonth" {
  test "returns a time which is at the beginning of the same month as the given time" {
    Time.atBeginningOfMonth(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 1)
  }
}

suite "Time.atBeginningOfWeek" {
  test "returns a time which is at the beginning of the same week as the given time" {
    Time.atBeginningOfWeek(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 15)
  }
}

suite "Time.atBeginningOfDay" {
  test "returns a time which is at the beginning of the same day as the given time" {
    Time.atBeginningOfDay(Time.utc(2017, 5, 20, 10, 34, 22, 40)) == Time.utc(2017, 5, 20, 0, 0, 0, 0)
  }
}

suite "Time.atEndOfYear" {
  test "returns a time which is at the end of the same year as the given time" {
    Time.atEndOfYear(Time.utcDate(2017, 5, 20)) == Time.utc(2017, 12, 31, 23, 59, 59, 999)
  }
}

suite "Time.atEndOfMonth" {
  test "returns a time which is at the end of the same month as the given time" {
    Time.atEndOfMonth(Time.utcDate(2017, 5, 20)) == Time.utc(2017, 5, 31, 23, 59, 59, 999)
  }
}

suite "Time.atEndOfWeek" {
  test "returns a time which is at the end of the same week as the given time" {
    Time.atEndOfWeek(Time.utcDate(2017, 5, 20)) == Time.utc(2017, 5, 21, 23, 59, 59, 999)
  }
}

suite "Time.atEndOfDay" {
  test "returns a time which is at the end of the same day as the given time" {
    Time.atEndOfDay(Time.utc(2017, 5, 20, 10, 34, 22, 40)) == Time.utc(2017, 5, 20, 23, 59, 59, 999)
  }
}

suite "Time.nextMonth" {
  test "returns the next month of the time" {
    Time.nextMonth(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 6, 20)
  }
}

suite "Time.previousMonth" {
  test "returns the next month of the time" {
    Time.previousMonth(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 4, 20)
  }
}

suite "Time.nextWeek" {
  test "returns the next week of the time" {
    Time.nextWeek(Time.utcDate(2017, 5, 10)) == Time.utcDate(2017, 5, 17)
  }
}

suite "Time.previousWeek" {
  test "returns the previous week of the time" {
    Time.previousWeek(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 13)
  }
}

suite "Time.nextDay" {
  test "returns the next day of the time" {
    Time.nextDay(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 21)
  }
}

suite "Time.previousDay" {
  test "returns the next day of the time" {
    Time.previousDay(Time.utcDate(2017, 5, 20)) == Time.utcDate(2017, 5, 19)
  }
}

suite "Time.range" {
  test "it returns the days between the given days (inclusive)" {
    Time.range(Time.utcDate(2006, 4, 1), Time.utcDate(2006, 4, 4)) == [
      Time.utcDate(2006, 4, 1),
      Time.utcDate(2006, 4, 2),
      Time.utcDate(2006, 4, 3),
      Time.utcDate(2006, 4, 4)
    ]
  }
}

suite "Time.inZone" {
  test "it returns a new time in the given time zone" {
    Time.inZone("America/New_York", Time.utc(2019, 1, 1, 7, 12, 35, 200)) == Maybe.Just(Time.utc(2019, 1, 1, 2, 12, 35, 200))
  }
}
