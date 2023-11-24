/*
A module for validating values (mostly used in forms).

A validation function gets the value (and other parameters) and an error to
return if the validation fails.

The error is a `Tuple(String, String)` where the first parameter is the key of
the field and the second is the error message.

The result of the validation is a `Maybe(error)`. If it's `Maybe.Nothing` then
there validation succeeded, otherwise it will be a `Maybe.Just(error)` meaning
the validation failed.

Here is an example of doing validation for a checkout form:

  errors =
    Validation.merge(
      [
        Validation.isNotBlank(firstName, {"firstName", "Please enter the first name."}),
        Validation.isNotBlank(message, {"message", "Please enter the message."}),
        Validation.isNotBlank(lastName, {"lastName", "Please enter the last name."}),
        Validation.isNotBlank(phone, {"phone", "Please enter the phone number."}),
        Validation.isNotBlank(email, {"email", "Please enter the email address."}),
        Validation.isValidEmail(email, {"email", "Please enter the a valid email address."}),
        Validation.isNotBlank(address, {"address", "Please enter the address."}),
        Validation.isNotBlank(city, {"city", "Please enter the city address."}),
        Validation.isNotBlank(country, {"country", "Please select the country."}),
        Validation.isNotBlank(zip, {"zip", "Please enter the zip code."}),
        Validation.isNumber(zip, {"zip", "The zip code can only contain numbers."}),
        Validation.hasExactNumberOfCharacters(zip, 5, {"zip", "The zip code needs to have 5 digits."})
      ])

Here the `errors` variable contains a `Map(String, Array(String))` where they key of
the field is the the key of the error and the value of the field is the error
messages for that key.

If the `errors` is empty that means that there are no errors.
*/
module Validation {
  const EMAIL_REGEXP =
    Regexp.createWithOptions(
      "^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-" \
      "Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-" \
      "]{0,61}[a-zA-Z0-9])?)*$",
      {
        caseInsensitive: true,
        multiline: false,
        unicode: false,
        global: false,
        sticky: false
      })

  const DIGITS_REGEXP =
    Regexp.createWithOptions(
      "^[0-9]+$",
      {
        caseInsensitive: true,
        multiline: false,
        unicode: false,
        global: false,
        sticky: false
      })

  /* Returns the first error for the given key in the given errors. */
  fun getFirstError (errors : Map(String, Array(String)), key : String) : Maybe(String) {
    errors
    |> Map.get(key)
    |> Maybe.map(Array.first)
    |> Maybe.flatten
  }

  /*
  Returns the given error if the given string is does not have the exact number
  of characters.

    Validation.hasExactNumberOfCharacters(
      "",
      5,
      {"zip", "Zip code does is not 5 characters!"}) ==
        Maybe.Just({"zip", "Zip code does is not 5 characters!"})
  */
  fun hasExactNumberOfCharacters (
    value : String,
    size : Number,
    error : Tuple(String, String)
  ) : Maybe(Tuple(String, String)) {
    if String.size(value) == size {
      Maybe.Nothing
    } else {
      Maybe.Just(error)
    }
  }

  /*
  Returns the given error if the given string does not have at least the given
  number of characters.

    Validation.hasMinimumNumberOfCharacters(
      "",
      5,
      {"zip", "Zip code does is not 5 characters or more!"}) ==
        Maybe.Just({"zip", "Zip code does is not 5 characters or more!"})
  */
  fun hasMinimumNumberOfCharacters (
    value : String,
    size : Number,
    error : Tuple(String, String)
  ) : Maybe(Tuple(String, String)) {
    if String.size(value) >= size {
      Maybe.Nothing
    } else {
      Maybe.Just(error)
    }
  }

  /*
  Returns the given error when the given string is blank
  (contains only whitespace).

    Validation.isNotBlank("", {"name", "Name is empty!"}) ==
      Maybe.Just({"name", "Name is empty!"})
  */
  fun isNotBlank (value : String, error : Tuple(String, String)) : Maybe(Tuple(String, String)) {
    if String.isNotBlank(value) {
      Maybe.Nothing
    } else {
      Maybe.Just(error)
    }
  }

  /*
  Returns the given error if the given string is not a number.

    Validation.isNumber("foo", {"multiplicand", "Multiplicand is not a number!"}) ==
      Maybe.Just({"multiplicand", "Multiplicand is not a number!"})
  */
  fun isNumber (value : String, error : Tuple(String, String)) : Maybe(Tuple(String, String)) {
    case Number.fromString(value) {
      Maybe.Just => Maybe.Nothing
      => Maybe.Just(error)
    }
  }

  /*
  Returns the given error if the given string does not consist of just digits.

    Validation.isDigits("1234x", {"zip", "Zip code is not just digits!"}) ==
      Maybe.Just({"zip", "Zip code is not just digits!"})
  */
  fun isDigits (value : String, error : Tuple(String, String)) : Maybe(Tuple(String, String)) {
    if Regexp.match(DIGITS_REGEXP, value) {
      Maybe.Nothing
    } else {
      Maybe.Just(error)
    }
  }

  /*
  Returns the given error if the two given values are not the same.

    Validation.isSame(
      "password",
      "confirmation",
      {"confirmation", "Confirmation is not the same!"}) ==
        Maybe.Just({"confirmation", "Confirmation is not the same!"})
  */
  fun isSame (value : a, value2 : a, error : Tuple(String, String)) : Maybe(Tuple(String, String)) {
    if value == value2 {
      Maybe.Nothing
    } else {
      Maybe.Just(error)
    }
  }

  /*
  Returns the given error if the given string is not an email address.

    Validation.isValidEmail(
      "test",
      {"email", "Email is not a valid email address!"}) ==
        Maybe.Just({"email", "Email is not a valid email address!"})
  */
  fun isValidEmail (value : String, error : Tuple(String, String)) : Maybe(Tuple(String, String)) {
    if Regexp.match(EMAIL_REGEXP, value) {
      Maybe.Nothing
    } else {
      Maybe.Just(error)
    }
  }

  /*
  Merges the result of many validations into a `Map(String, Array(String))`.

    Validation.merge([
      Validation.isNotBlank("", {"firstName", "Please enter the first name."}),
      Validation.isNotBlank("", {"message", "Please enter the message."}),
    ]) == (Map.empty()
      |> Map.set("firstName", "Please enter the first name.")
      |> Map.set("message", "Please enter the message."))
  */
  fun merge (errors : Array(Maybe(Tuple(String, String)))) : Map(String, Array(String)) {
    errors
    |> Array.reduce(
      Map.empty(),
      (
        memo : Map(String, Array(String)),
        item : Maybe(Tuple(String, String))
      ) : Map(String, Array(String)) {
        case item {
          Maybe.Just(error) =>
            {
              let {key, message} =
                error

              let messages =
                memo
                |> Map.get(key)
                |> Maybe.withDefault([])

              Map.set(memo, key, Array.push(messages, message))
            }

          => memo
        }
      })
  }
}
