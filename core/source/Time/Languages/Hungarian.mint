module Time.Format {
  /* The Hungarian language record for time formatting. */
  const HUNGARIAN =
    {
      toMonthAbbreviation:
        (month : Month) {
          case month {
            January => "jan."
            February => "febr."
            March => "márc."
            April => "ápr."
            May => "máj."
            June => "jún."
            July => "júl."
            August => "aug."
            September => "szept."
            October => "okt."
            November => "nov."
            December => "dec."
          }
        },
      toMonthName:
        (month : Month) {
          case month {
            January => "janár"
            February => "február"
            March => "március"
            April => "április"
            May => "május"
            June => "június"
            July => "július"
            August => "augusztus"
            September => "szeptember"
            October => "október"
            November => "november"
            December => "december"
          }
        },
      toWeekdayName:
        (weekday : Weekday) {
          case weekday {
            Monday => "hétfő"
            Tuesday => "kedd"
            Wednesday => "szerda"
            Thursday => "csütörtök"
            Friday => "péntek"
            Saturday => "szombat"
            Sunday => "vasárnap"
          }
        },
      toWeekdayAbbreviation:
        (weekday : Weekday) {
          case weekday {
            Monday => "hé"
            Tuesday => "ke"
            Wednesday => "sze."
            Thursday => "csü."
            Friday => "pé."
            Saturday => "szo."
            Sunday => "va."
          }
        },
      toOrdinalSuffix:
        (day : Number) {
          case day {
            1 => "-je"
            2 => "-a"
            3 => "-a"
            4 => "-e"
            5 => "-e"
            6 => "-a"
            7 => "-e"
            8 => "-a"
            9 => "-e"
            10 => "-e"
            11 => "-e"
            12 => "-e"
            13 => "-a"
            14 => "-e"
            15 => "-e"
            16 => "-a"
            17 => "-e"
            18 => "-a"
            19 => "-e"
            20 => "-a"
            21 => "-e"
            22 => "-e"
            23 => "-a"
            24 => "-e"
            25 => "-e"
            26 => "-a"
            27 => "-e"
            28 => "-a"
            29 => "-e"
            30 => "-a"
            31 => "-e"
            => ""
          }
        },
      amPm:
        (hour : Number) {
          if hour >= 12 {
            "du."
          } else {
            "de."
          }
        },
      someSecondsAgo:
        (seconds : Number) {
          if seconds < 30 {
            "épp most"
          } else {
            "#{seconds} másodperce"
          }
        },
      someMinutesAgo:
        (minutes : Number) {
          if minutes < 2 {
            "egy perce"
          } else {
            "#{minutes} perce"
          }
        },
      someHoursAgo:
        (hours : Number) {
          if hours < 2 {
            "egy órája"
          } else {
            "#{hours} órája"
          }
        },
      someDaysAgo:
        (days : Number) {
          if days < 2 {
            "tegnap"
          } else {
            "#{days} napja"
          }
        },
      someMonthsAgo:
        (months : Number) {
          if months < 2 {
            "egy hónapja"
          } else {
            "#{months} hónapja"
          }
        },
      someYearsAgo:
        (years : Number) {
          if years < 2 {
            "egy éve"
          } else {
            "#{years} éve"
          }
        },
      inSomeSeconds:
        (seconds : Number) {
          if seconds < 30 {
            "nemsokára"
          } else {
            "#{seconds} másodperc múlva"
          }
        },
      inSomeMinutes:
        (minutes : Number) {
          if minutes < 2 {
            "egy perc múlva"
          } else {
            "#{minutes} perc múlva"
          }
        },
      inSomeHours:
        (hours : Number) {
          if hours < 2 {
            "egy óra múlva"
          } else {
            "#{hours} óra múlva"
          }
        },
      inSomeDays:
        (days : Number) {
          if days < 2 {
            "holnap"
          } else {
            "#{days} nam múlva"
          }
        },
      inSomeMonths:
        (months : Number) {
          if months < 2 {
            "egy hónap múlva"
          } else {
            "#{months} hónap múlva"
          }
        },
      inSomeYears:
        (years : Number) {
          if years < 2 {
            "egy év múlva"
          } else {
            "#{years} év múlva"
          }
        },
      rightNow: "épp most"
    }
}
