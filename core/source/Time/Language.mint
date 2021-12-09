/* Represents a language for time formatting. */
record Time.Format.Language {
  toOrdinalSuffix : Function(Number, String),
  toMonthName : Function(Month, String),
  toMonthAbbreviation : Function(Month, String),
  toWeekdayName : Function(Weekday, String),
  toWeekdayAbbreviation : Function(Weekday, String),
  amPm : Function(Number, String)
}
