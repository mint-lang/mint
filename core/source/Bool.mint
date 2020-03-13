/* Functions for handling boolean values. */
module Bool {
  /*
  Converts a boolean to a string.

    Bool.toString(true) == "true"
    Bool.toString(false) == "false"
  */
  toString (item : Bool) : String {
    `#{item}.toString()`
  }
}
