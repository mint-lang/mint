/* Represents a language for time formatting. */
record Time.Format.Language {
  toOrdinalSuffix : Function(Number, String),
  toMonthName : Function(Month, String),
  toMonthAbbreviation : Function(Month, String),
  toWeekdayName : Function(Weekday, String),
  toWeekdayAbbreviation : Function(Weekday, String),
  amPm : Function(Number, String),
  someSecondsAgo : Function(Number, String),
  someMinutesAgo : Function(Number, String),
  someHoursAgo : Function(Number, String),
  someDaysAgo : Function(Number, String),
  someMonthsAgo : Function(Number, String),
  someYearsAgo : Function(Number, String),
  inSomeSeconds : Function(Number, String),
  inSomeMinutes : Function(Number, String),
  inSomeHours : Function(Number, String),
  inSomeDays : Function(Number, String),
  inSomeMonths : Function(Number, String),
  inSomeYears : Function(Number, String),
  rightNow : String
}
