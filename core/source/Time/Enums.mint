/* Represents a duration (span) of time. */
type Time.Span {
  Milliseconds(Number)
  Seconds(Number)
  Minutes(Number)
  Hours(Number)
  Days(Number)
  Weeks(Number)
  Months(Number)
  Years(Number)
}

/* Represents a month of the week in the Gregorian calendar. */
type Month {
  January
  February
  March
  April
  May
  June
  July
  August
  September
  October
  November
  December
}

/* Represents a day of the week in the Gregorian calendar. */
type Weekday {
  Monday
  Tuesday
  Wednesday
  Thursday
  Friday
  Saturday
  Sunday
}
