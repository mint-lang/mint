suite "Time equality" {
  test "returns true if the two times are equal" {
    Time.today() == Time.today()
  }

  test "returns false if the two times are not equal" {
    Time.now() != Time.today()
  }
}

suite "Time.toIso" {
  test "returns iso formatted string of the time" {
    (Time.from(2018, 4, 5)
    |> Time.toIso()) == "2018-04-05T00:00:00.000Z"
  }
}

suite "Time.fromIso" {
  test "returns the time from an ISO string" {
    (Time.today()
    |> Time.toIso()
    |> Time.fromIso()
    |> Maybe.withDefault(Time.now())) == Time.today()
  }
}

suite "Time.today" {
  test "returns the time as it is today" {
    Time.today() == Time.today()
  }
}

suite "Time.day" {
  test "returns the day of the time" {
    (Time.from(2018, 4, 5)
    |> Time.day()) == 5
  }
}

suite "Time.month" {
  test "returns the month of the time" {
    (Time.from(2018, 4, 5)
    |> Time.month()) == 4
  }
}

suite "Time.year" {
  test "returns the year of the time" {
    (Time.from(2018, 4, 5)
    |> Time.year()) == 2018
  }
}

suite "Time.nextMonth" {
  test "returns the next month of the time" {
    (Time.from(2018, 4, 5)
    |> Time.nextMonth()
    |> Time.toIso()) == "2018-05-05T00:00:00.000Z"
  }
}
