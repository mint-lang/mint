module Time.Format {
  /* The English language record for time formatting. */
  const ENGLISH =
    {
      toMonthAbbreviation =
        (month : Month) {
          case (month) {
            Month::January => "Jan"
            Month::February => "Feb"
            Month::March => "Mar"
            Month::April => "Apr"
            Month::May => "May"
            Month::June => "Jun"
            Month::July => "Jul"
            Month::August => "Aug"
            Month::September => "Sep"
            Month::October => "Oct"
            Month::November => "Nov"
            Month::December => "Dec"
          }
        },
      toMonthName =
        (month : Month) {
          case (month) {
            Month::January => "January"
            Month::February => "February"
            Month::March => "March"
            Month::April => "April"
            Month::May => "May"
            Month::June => "June"
            Month::July => "July"
            Month::August => "August"
            Month::September => "September"
            Month::October => "October"
            Month::November => "November"
            Month::December => "December"
          }
        },
      toWeekdayName =
        (weekday : Weekday) {
          case (weekday) {
            Weekday::Monday => "Monday"
            Weekday::Tuesday => "Tuesday"
            Weekday::Wednesday => "Wednesday"
            Weekday::Thursday => "Thursday"
            Weekday::Friday => "Friday"
            Weekday::Saturday => "Saturday"
            Weekday::Sunday => "Sunday"
          }
        },
      toWeekdayAbbreviation =
        (weekday : Weekday) {
          case (weekday) {
            Weekday::Monday => "Mon"
            Weekday::Tuesday => "Tue"
            Weekday::Wednesday => "Wed"
            Weekday::Thursday => "Thu"
            Weekday::Friday => "Fri"
            Weekday::Saturday => "Sat"
            Weekday::Sunday => "Sun"
          }
        },
      toOrdinalSuffix =
        (day : Number) {
          case (day % 100) {
            11 => "th"
            12 => "th"
            13 => "th"

            =>
              case (day % 10) {
                1 => "st"
                2 => "nd"
                3 => "rd"
                => "th"
              }
          }
        },
      amPm =
        (hour : Number) {
          if (hour >= 12) {
            "pm"
          } else {
            "am"
          }
        },
      someSecondsAgo =
        (seconds : Number) {
          if (seconds < 30) {
            "just now"
          } else {
            "#{seconds} seconds ago"
          }
        },
      someMinutesAgo =
        (minutes : Number) {
          if (minutes < 2) {
            "a minute ago"
          } else {
            "#{minutes} minutes ago"
          }
        },
      someHoursAgo =
        (hours : Number) {
          if (hours < 2) {
            "an hour ago"
          } else {
            "#{hours} hours ago"
          }
        },
      someDaysAgo =
        (days : Number) {
          if (days < 2) {
            "yesterday"
          } else {
            "#{days} days ago"
          }
        },
      someMonthsAgo =
        (months : Number) {
          if (months < 2) {
            "last month"
          } else {
            "#{months} months ago"
          }
        },
      someYearsAgo =
        (years : Number) {
          if (years < 2) {
            "last year"
          } else {
            "#{years} years ago"
          }
        },
      inSomeSeconds =
        (seconds : Number) {
          if (seconds < 30) {
            "in a few seconds"
          } else {
            "in #{seconds} seconds"
          }
        },
      inSomeMinutes =
        (minutes : Number) {
          if (minutes < 2) {
            "in a minute"
          } else {
            "in #{minutes} minutes"
          }
        },
      inSomeHours =
        (hours : Number) {
          if (hours < 2) {
            "in an hour"
          } else {
            "in #{hours} hours"
          }
        },
      inSomeDays =
        (days : Number) {
          if (days < 2) {
            "tomorrow"
          } else {
            "in #{days} days"
          }
        },
      inSomeMonths =
        (months : Number) {
          if (months < 2) {
            "in a month"
          } else {
            "in #{months} months"
          }
        },
      inSomeYears =
        (years : Number) {
          if (years < 2) {
            "in a year"
          } else {
            "in #{years} years"
          }
        },
      rightNow = "right now"
    }
}
