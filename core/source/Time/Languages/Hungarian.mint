module Time.Format {
  /* The Hungarian language record for time formatting. */
  const HUNGARIAN =
    {
      toMonthAbbreviation:
        (month : Month) {
          case (month) {
            Month::January => "jan."
            Month::February => "febr."
            Month::March => "márc."
            Month::April => "ápr."
            Month::May => "máj."
            Month::June => "jún."
            Month::July => "júl."
            Month::August => "aug."
            Month::September => "szept."
            Month::October => "okt."
            Month::November => "nov."
            Month::December => "dec."
          }
        },
      toMonthName:
        (month : Month) {
          case (month) {
            Month::January => "janár"
            Month::February => "február"
            Month::March => "március"
            Month::April => "április"
            Month::May => "május"
            Month::June => "június"
            Month::July => "július"
            Month::August => "augusztus"
            Month::September => "szeptember"
            Month::October => "október"
            Month::November => "november"
            Month::December => "december"
          }
        },
      toWeekdayName:
        (weekday : Weekday) {
          case (weekday) {
            Weekday::Monday => "hétfő"
            Weekday::Tuesday => "kedd"
            Weekday::Wednesday => "szerda"
            Weekday::Thursday => "csütörtök"
            Weekday::Friday => "péntek"
            Weekday::Saturday => "szombat"
            Weekday::Sunday => "vasárnap"
          }
        },
      toWeekdayAbbreviation:
        (weekday : Weekday) {
          case (weekday) {
            Weekday::Monday => "hé"
            Weekday::Tuesday => "ke"
            Weekday::Wednesday => "sze."
            Weekday::Thursday => "csü."
            Weekday::Friday => "pé."
            Weekday::Saturday => "szo."
            Weekday::Sunday => "va."
          }
        },
      toOrdinalSuffix:
        (day : Number) {
          case (day) {
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
          if (hour >= 12) {
            "du."
          } else {
            "de."
          }
        },
      someSecondsAgo:
        (seconds : Number) {
          if (seconds < 30) {
            "épp most"
          } else {
            "#{seconds} másodperce"
          }
        },
      someMinutesAgo:
        (minutes : Number) {
          if (minutes < 2) {
            "egy perce"
          } else {
            "#{minutes} perce"
          }
        },
      someHoursAgo:
        (hours : Number) {
          if (hours < 2) {
            "egy órája"
          } else {
            "#{hours} órája"
          }
        },
      someDaysAgo:
        (days : Number) {
          if (days < 2) {
            "tegnap"
          } else {
            "#{days} napja"
          }
        },
      someMonthsAgo:
        (months : Number) {
          if (months < 2) {
            "egy hónapja"
          } else {
            "#{months} hónapja"
          }
        },
      someYearsAgo:
        (years : Number) {
          if (years < 2) {
            "egy éve"
          } else {
            "#{years} éve"
          }
        },
      inSomeSeconds:
        (seconds : Number) {
          if (seconds < 30) {
            "nemsokára"
          } else {
            "#{seconds} másodperc múlva"
          }
        },
      inSomeMinutes:
        (minutes : Number) {
          if (minutes < 2) {
            "egy perc múlva"
          } else {
            "#{minutes} perc múlva"
          }
        },
      inSomeHours:
        (hours : Number) {
          if (hours < 2) {
            "egy óra múlva"
          } else {
            "#{hours} óra múlva"
          }
        },
      inSomeDays:
        (days : Number) {
          if (days < 2) {
            "holnap"
          } else {
            "#{days} nam múlva"
          }
        },
      inSomeMonths:
        (months : Number) {
          if (months < 2) {
            "egy hónap múlva"
          } else {
            "#{months} hónap múlva"
          }
        },
      inSomeYears:
        (years : Number) {
          if (years < 2) {
            "egy év múlva"
          } else {
            "#{years} év múlva"
          }
        },
      rightNow: "épp most"
    }
}
