suite "Time.formatISO" {
  test "returns iso formatted string of the time" {
    Time.formatISO(Time.utcDate(2018, 4, 5)) == "2018-04-05T00:00:00.000Z"
  }
}

suite "Time.distanceOfTimeInWords" {
  const TEST_DATA =
    [
      {Seconds(0) cast Time.Span, "right now"},
      {Seconds(-24) cast Time.Span, "just now"},
      {Seconds(-40) cast Time.Span, "40 seconds ago"},
      {Minutes(-1) cast Time.Span, "a minute ago"},
      {Minutes(-9) cast Time.Span, "9 minutes ago"},
      {Hours(-1) cast Time.Span, "an hour ago"},
      {Hours(-3) cast Time.Span, "3 hours ago"},
      {Days(-1) cast Time.Span, "yesterday"},
      {Days(-4) cast Time.Span, "4 days ago"},
      {Months(-1) cast Time.Span, "last month"},
      {Months(-5) cast Time.Span, "5 months ago"},
      {Years(-1) cast Time.Span, "last year"},
      {Years(-20) cast Time.Span, "20 years ago"},
      {Seconds(0) cast Time.Span, "right now"},
      {Seconds(24) cast Time.Span, "in a few seconds"},
      {Seconds(40) cast Time.Span, "in 40 seconds"},
      {Minutes(1) cast Time.Span, "in a minute"},
      {Minutes(9) cast Time.Span, "in 9 minutes"},
      {Hours(1) cast Time.Span, "in an hour"},
      {Hours(3) cast Time.Span, "in 3 hours"},
      {Days(1) cast Time.Span, "tomorrow"},
      {Days(4) cast Time.Span, "in 4 days"},
      {Months(1) cast Time.Span, "in a month"},
      {Months(5) cast Time.Span, "in 5 months"},
      {Years(1) cast Time.Span, "in a year"},
      {Years(20) cast Time.Span, "in 20 years"}
    ]

  test "returns relative time in words" {
    let now =
      Time.utc(2016, 1, 1, 12, 34, 50, 200)

    let expected =
      for item of TEST_DATA {
        item[1]
      }
      |> String.join("\n")

    let actual =
      for item of TEST_DATA {
        Time.distanceOfTimeInWords(Time.shift(now, item[0]), now,
          Time.Format.ENGLISH)
      }
      |> String.join("\n")

    actual == expected
  }
}

suite "Time.format" {
  const TEST_DATA =
    [
      {Time.utcDate(1985, 4, 12), "%G-W%V-%u", "1985-W15-5"},
      {Time.utcDate(2005, 1, 1), "%G-W%V-%u", "2004-W53-6"},
      {Time.utcDate(2005, 1, 2), "%G-W%V-%u", "2004-W53-7"},
      {Time.utcDate(2005, 12, 31), "%G-W%V-%u", "2005-W52-6"},
      {Time.utcDate(2006, 1, 1), "%G-W%V-%u", "2005-W52-7"},
      {Time.utcDate(2006, 1, 2), "%G-W%V-%u", "2006-W01-1"},
      {Time.utcDate(2006, 12, 31), "%G-W%V-%u", "2006-W52-7"},
      {Time.utcDate(2007, 1, 1), "%G-W%V-%u", "2007-W01-1"},
      {Time.utcDate(2007, 12, 30), "%G-W%V-%u", "2007-W52-7"},
      {Time.utcDate(2007, 12, 31), "%G-W%V-%u", "2008-W01-1"},
      {Time.utcDate(2008, 1, 1), "%G-W%V-%u", "2008-W01-2"},
      {Time.utcDate(2008, 12, 28), "%G-W%V-%u", "2008-W52-7"},
      {Time.utcDate(2008, 12, 29), "%G-W%V-%u", "2009-W01-1"},
      {Time.utcDate(2008, 12, 30), "%G-W%V-%u", "2009-W01-2"},
      {Time.utcDate(2008, 12, 31), "%G-W%V-%u", "2009-W01-3"},
      {Time.utcDate(2009, 1, 1), "%G-W%V-%u", "2009-W01-4"},
      {Time.utcDate(2009, 12, 31), "%G-W%V-%u", "2009-W53-4"},
      {Time.utcDate(2010, 1, 1), "%G-W%V-%u", "2009-W53-5"},
      {Time.utcDate(2010, 1, 2), "%G-W%V-%u", "2009-W53-6"},
      {Time.utcDate(2010, 1, 3), "%G-W%V-%u", "2009-W53-7"},
      {Time.utcDate(1985, 4, 12), "%g-W%V-%u", "85-W15-5"}
    ]

  test "formats parts correctly" {
    let expected =
      for item of TEST_DATA {
        item[2]
      }
      |> String.join("\n")

    let actual =
      for item of TEST_DATA {
        Time.format(item[0], Time.Format.ENGLISH, item[1])
      }
      |> String.join("\n")

    actual == expected
  }
}
