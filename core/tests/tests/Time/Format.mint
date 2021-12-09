suite "Time.format" {
  const FORMAT_TEST_DATA =
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
    try {
      expected =
        for (item of FORMAT_TEST_DATA) {
          item[2]
        }
        |> String.join("\n")

      actual =
        for (item of FORMAT_TEST_DATA) {
          Time.format(Time.Format:ENGLISH, item[1], item[0])
        }
        |> String.join("\n")

      actual == expected
    }
  }
}
