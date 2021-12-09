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

suite "Time.formatISO" {
  test "returns iso formatted string of the time" {
    (Time.utcDate(2018, 4, 5)
    |> Time.formatISO()) == "2018-04-05T00:00:00.000Z"
  }
}

suite "Time.today" {
  test "returns the time as it is today" {
    Time.today() == Time.today()
  }
}

suite "Time.dayOfMonth" {
  test "returns the day of the month of the time" {
    (Time.utcDate(2018, 4, 5)
    |> Time.dayOfMonth()) == 5
  }
}

suite "Time.dayOfYear" {
  test "returns the day of the year of the time" {
    (Time.utcDate(2018, 4, 5)
    |> Time.dayOfYear()) == 95
  }
}

suite "Time.month" {
  test "returns the month of the time" {
    (Time.utcDate(2018, 4, 5)
    |> Time.month()) == Month::April
  }
}

suite "Time.year" {
  test "returns the year of the time" {
    (Time.utcDate(2018, 4, 5)
    |> Time.year()) == 2018
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

suite "Time.unix" {
  test "returns the UTC time from the given UNIX Timestamp (in Milliseconds)" {
    (Time.unix(1522886400000)
    |> Time.formatISO()) == "2018-04-05T00:00:00.000Z"
  }
}

suite "Time.toUnix" {
  test "returns the UNIX Timestamp (in Milliseconds)" {
    (Time.utcDate(2018, 4, 5)
    |> Time.toUnix()) == 1522886400000
  }
}

suite "Time.calendarWeek" {
  const CALENDAR_WEEK_TEST_DATA =
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
    try {
      expected =
        for (item of CALENDAR_WEEK_TEST_DATA) {
          {item[1][0], item[1][1]}
        }

      actual =
        for (item of CALENDAR_WEEK_TEST_DATA) {
          Time.utcDate(item[0][0], item[0][1], item[0][2])
          |> Time.calendarWeek
        }

      `console.log(#{expected}.join("\n"))`
      `console.log(#{actual}.join("\n"))`

      expected == actual
    }
  }
}
