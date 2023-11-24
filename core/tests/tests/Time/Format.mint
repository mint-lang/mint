suite "Time.formatISO" {
  test "returns iso formatted string of the time" {
    Time.formatISO(Time.utcDate(2018, 4, 5)) == "2018-04-05T00:00:00.000Z"
  }
}

suite "Time.distanceOfTimeInWords" {
  const TEST_DATA =
    [
      {Time.Span.Seconds(0), "right now"},
      {Time.Span.Seconds(-24), "just now"},
      {Time.Span.Seconds(-40), "40 seconds ago"},
      {Time.Span.Minutes(-1), "a minute ago"},
      {Time.Span.Minutes(-9), "9 minutes ago"},
      {Time.Span.Hours(-1), "an hour ago"},
      {Time.Span.Hours(-3), "3 hours ago"},
      {Time.Span.Days(-1), "yesterday"},
      {Time.Span.Days(-4), "4 days ago"},
      {Time.Span.Months(-1), "last month"},
      {Time.Span.Months(-5), "5 months ago"},
      {Time.Span.Years(-1), "last year"},
      {Time.Span.Years(-20), "20 years ago"},
      {Time.Span.Seconds(0), "right now"},
      {Time.Span.Seconds(24), "in a few seconds"},
      {Time.Span.Seconds(40), "in 40 seconds"},
      {Time.Span.Minutes(1), "in a minute"},
      {Time.Span.Minutes(9), "in 9 minutes"},
      {Time.Span.Hours(1), "in an hour"},
      {Time.Span.Hours(3), "in 3 hours"},
      {Time.Span.Days(1), "tomorrow"},
      {Time.Span.Days(4), "in 4 days"},
      {Time.Span.Months(1), "in a month"},
      {Time.Span.Months(5), "in 5 months"},
      {Time.Span.Years(1), "in a year"},
      {Time.Span.Years(20), "in 20 years"}
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
        Time.distanceOfTimeInWords(Time.shift(now, item[0]), now, Time.Format.ENGLISH)
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
