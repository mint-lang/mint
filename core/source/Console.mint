/*
This store for saving the value of the console counters.

```
Console.Counter.increment("My Label")
Console.Counter.get("My Label") // 1
Console.Counter.clear("My Label")
Console.Counter.get("My Label") // 0
```
*/
store Console.Counter {
  // State for the counts of each counter.
  state counts : Map(String, Number) = Map.empty()

  // Resets the counter with the label to 0.
  fun clear (label : String = "Default") : Promise(Void) {
    next { counts: Map.set(counts, label, 0) }
  }

  // Returns the current count of the counter with the label.
  fun get (label : String = "Default") : Number {
    Map.getWithDefault(counts, label, 0)
  }

  // Increments the counter with the label.
  fun increment (label : String = "Default") : Promise(Void) {
    let currentValue =
      Map.getWithDefault(counts, label, 0)

    next { counts: Map.set(counts, label, currentValue + 1) }
  }
}

/*
This module provides functions to work with the [Console Web API].

[Console Web API]: https://developer.mozilla.org/en-US/docs/Web/API/Console_API
*/
module Console {
  /*
  If the assertion is `false`, the message is written to the console. Supports
  string substitution. For more information check out the [`console.assert()`]
  function.

  [`console.assert()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/assert

    Console.assert(false, "Message...") // This will not print the message.
    Console.assert(true, "Message...") // This will print the message.
  */
  fun assert (assertion : Bool, value : a, values : Array(b) = []) : Tuple(Bool, a, Array(b)) {
    `console.assert(#{assertion}, #{value}, ...#{values})`
    {assertion, value, values}
  }

  /*
  Clears the console. For more information check out the [`console.clear()`]
  function.

  [`console.clear()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/clear

    Console.clear()
  */
  fun clear : Void {
    `console.clear()`
  }

  /*
  Logs the number of times that this particular call to `count` has been called.
  Returns the label passed along with the current count. For more information
  check out the [`console.count()`] function.

  [`console.count()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/count

    Console.count()          // {"Default", 1}
    Console.count("Default") // {"Default", 2}
    Console.count("Test")    // {"Test", 1}
  */
  fun count (label : String = "Default") : Tuple(String, Number) {
    `console.count(#{label})`
    Console.Counter.increment(label)

    {label, Console.Counter.get(label)}
  }

  /*
  Resets the counter used with `count`. Returns the label passed along with the
  current count. For more information check out the [`console.countReset()`]
  function.

  [`console.countReset()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/countReset

    Console.count()         // {"Default", 1}
    Console.count()         // {"Default", 2}
    Console.countReset()    // {"Default", 0}
  */
  fun countReset (label : String = "Default") : Tuple(String, Number) {
    `console.countReset(#{label})`
    Console.Counter.clear(label)

    {label, Console.Counter.get(label)}
  }

  /*
  Outputs a message to the Web Console at the "debug" log level. The message is
  only displayed to the user if the console is configured to display debug
  output. Supports string substitution. For more information check out the
  [`console.debug()`] function.

  [`console.debug()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/debug

    Console.debug("The message...")
  */
  fun debug (value : a, values : Array(b) = []) : Tuple(a, Array(b)) {
    `console.debug(#{value}, ...#{values})`
    {value, values}
  }

  /*
  Displays an interactive list of the properties of the generated JavaScript
  object. For more information check out the [`console.dir()`] function.

  [`console.dir()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/dir

    Console.dir(`{key: "value"}`)
  */
  fun dir (value : a) : a {
    `console.dir(#{value})`
    value
  }

  /*
  Displays an interactive tree of the descendant elements of the specified
  XML/HTML element. For more information check out the [`console.dirxml()`]
  function.

  [`console.dirxml()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/dirxml

    if let Just(element) = Dom.getElementBySelector("body") {
      Console.dirxml(element)
    }
  */
  fun dirxml (value : a) : a {
    `console.dirxml(#{value})`
    value
  }

  /*
  Outputs an error message to the Web Console. Supports string substitution.
  For more information check out the [`console.error()`] function.

  [`console.error()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/error

    Console.error("Something went wrong!")
  */
  fun error (value : a, values : Array(b) = []) : Tuple(a, Array(b)) {
    `console.error(#{value}, ...#{values})`
    {value, values}
  }

  /*
  Creates a new inline group in the Web Console log. For more information check
  out the [`console.group()`] function.

  [`console.group()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/group

    Console.group("My Group")
    Console.log("Some information...")
    Console.groupEnd()
  */
  fun group (label : String = "Default") : String {
    `console.group(#{label})`
    label
  }

  /*
  Creates a new inline group in the Web Console log. The new group is created
  collapsed. For more information check out the [`console.groupCollapsed()`]
  function.

  [`console.groupCollapsed()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/groupCollapsed

    Console.groupCollapsed("My Group")
    Console.log("Some information...")
    Console.groupEnd()
  */
  fun groupCollapsed (label : String = "Default") : String {
    `console.groupCollapsed(#{label})`
    label
  }

  /*
  Exits the current inline group in the Web Console. For more information check
  out the [`console.groupEnd()`] function.

  [`console.groupEnd()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/groupEnd

    Console.group("My Group")
    Console.log("Some information...")
    Console.groupEnd()
  */
  fun groupEnd (label : String = "Default") : String {
    `console.groupEnd(#{label})`
    label
  }

  /*
  Outputs an informational message to the Web Console. Supports string
  substitution. For more information check out the [`console.info()`] function.

  [`console.info()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/info

    Console.info("I'm cute!")
  */
  fun info (value : a, values : Array(b) = []) : Tuple(a, Array(b)) {
    `console.info(#{value}, ...#{values})`
    {value, values}
  }

  /*
  Outputs a message to the Web Console. Supports string substitution. For more
  information check out the [`console.log()`] function.

  [`console.log()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/log

    Console.log("Hello ", ["World", "!"]) => "Hello World!"
  */
  fun log (value : a, values : Array(b) = []) : Tuple(a, Array(b)) {
    `console.log(#{value}, ...#{values})`
    {value, values}
  }

  /*
  **NON-STANDARD**: Starts recording a performance profile. For more information
  check out the [`console.profile()`] function.

  [`console.profile()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/profile

    Console.profile("My Profile")
    // Do something...
    Console.profileEnd("My Profile")
  */
  fun profile (profileName : String = "Default") : String {
    if `!console.profile` {
      Debug.log("Your browser does not support console.profile")
    } else {
      `console.profile(#{profileName})`
    }

    profileName
  }

  /*
  **NON-STANDARD**: Stops recording a previously started performance profile.
  For more information check out the [`console.profileEnd()`] function.

  [`console.profileEnd()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/profileEnd

    Console.profile("My Profile")
    // Do something...
    Console.profileEnd("My Profile")
  */
  fun profileEnd (profileName : String = "Default") : String {
    if `!console.profileEnd` {
      Debug.log("Your browser does not support console.profileEnd")
    } else {
      `console.profileEnd(#{profileName})`
    }

    profileName
  }

  /*
  Logs data as a table. For more information check out the [`console.table()`]
  function.

  [`console.table()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/table

    Console.table({ name: "Joe" })
  */
  fun table (data : a, columns : Array(String) = []) : Tuple(a, Array(String)) {
    if columns != [] {
      `console.table(#{data}, #{columns})`
    } else {
      `console.table(#{data})`
    }

    {data, columns}
  }

  /*
  Starts a timer. For more information check out the [`console.time()`]
  function.

  [`console.time()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/time

    Console.time("My Timer")
    // Do some stuff...
    Console.timeEnd("My Timer")
  */
  fun time (label : String = "Default") : String {
    `console.time(#{label})`
    label
  }

  /*
  Stops a timer that was previously started. For more information check out the
  [`console.timeEnd()`] function.

  [`console.timeEnd()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/timeEnd

    Console.time("My Timer")
    // Do some stuff...
    Console.timeEnd("My Timer")
  */
  fun timeEnd (label : String = "Default") : String {
    `console.timeEnd(#{label})`
    label
  }

  /*
  Logs the current value of a timer that was previously started. For more
  information check out the [`console.timeLog()`] function.

  [`console.timeLog()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/timeLog

    Console.time("My Timer")
    // Do some stuff...
    Console.timeLog("My Timer")
    Console.timeEnd("My Timer")
  */
  fun timeLog (label : String = "Default", values : Array(a) = []) : Tuple(String, Array(a)) {
    `console.timeLog(#{label}, ...#{values})`
    {label, values}
  }

  /*
  **NON-STANDARD**: Adds a single marker to the browser's performance tool. For
  more information check out the [`console.timestamp()`] function.

  [`console.timestamp()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/timestamp

    Console.timestamp("My Timestamp")
  */
  fun timestamp (label : String = "Default") : String {
    if `!console.timestamp` {
      Debug.log("Your browser does not support console.timestamp")
    } else {
      `console.timestamp(#{label})`
    }

    label
  }

  /*
  Outputs a stack trace to the Web Console. Does not support string
  substitution. For more information check out the [`console.trace()`]
  function.

  [`console.trace()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/trace

    Console.trace("Value")
  */
  fun trace (value : a, values : Array(b)) : Tuple(a, Array(b)) {
    `console.trace(#{value}, ...#{values})`
    {value, values}
  }

  /*
  Outputs a warning message to the Web Console. For more information check out
  the [`console.warn()`] function.

  [`console.warn()`]: https://developer.mozilla.org/en-US/docs/Web/API/console/warn

    Console.warn("Something fishy is going on...")
  */
  fun warn (value : a, values : Array(b) = []) : Tuple(a, Array(b)) {
    `console.warn(#{value}, ...#{values})`
    {value, values}
  }
}
