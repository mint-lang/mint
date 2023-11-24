store Console.Counter {
  state counts : Map(String, Number) = Map.empty()

  fun increment (label : String = "Default") {
    next
      {
        counts:
          case Map.has(counts, label) {
            false => Map.set(counts, label, 1)
            => Map.set(counts, label, Map.getWithDefault(counts, label, 0) + 1)
          }
      }
  }

  fun clear (label : String = "Default") {
    next { counts: Map.set(counts, label, 0) }
  }

  fun get (label : String = "Default") : Number {
    Map.getWithDefault(counts, label, 0)
  }
}

/* Module to work with the [Console API](https://developer.mozilla.org/en-US/docs/Web/API/Console_API). */
module Console {
  /*
  If the assertion is false, the message is written to the console. Supports string substitution.

  [assert()](https://developer.mozilla.org/en-US/docs/Web/API/console/assert)
  */
  fun assert (assertion : Bool, value : a, values : Array(b) = []) : Tuple(Bool, a, Array(b)) {
    `console.assert(#{assertion}, #{value}, ...#{values})`
    {assertion, value, values}
  }

  /*
  Clears the console.

  [clear()](https://developer.mozilla.org/en-US/docs/Web/API/console/clear)
  */
  fun clear : Void {
    `console.clear()`
  }

  /*
  Logs the number of times that this particular call to count() has been called.
  Returns the label passed along with the current count.

  [count()](https://developer.mozilla.org/en-US/docs/Web/API/console/count)
  */
  fun count (label : String = "Default") : Tuple(String, Number) {
    `console.count(#{label})`
    Console.Counter.increment(label)

    {label, Console.Counter.get(label)}
  }

  /*
  Resets the counter used with Console.count().
  Returns the label passed along with the current count.

  [countReset()](https://developer.mozilla.org/en-US/docs/Web/API/console/countReset)
  */
  fun countReset (label : String = "Default") : Tuple(String, Number) {
    `console.countReset(#{label})`
    Console.Counter.clear(label)

    {label, Console.Counter.get(label)}
  }

  /*
  Outputs a message to the Web Console at the "debug" log level.
  The message is only displayed to the user if the console is configured to display debug output.
  Supports string substitution.

  [debug()](https://developer.mozilla.org/en-US/docs/Web/API/console/debug)
  */
  fun debug (value : a, values : Array(b) = []) : Tuple(a, Array(b)) {
    `console.debug(#{value}, ...#{values})`
    {value, values}
  }

  /*
  Displays an interactive list of the properties of the generated JavaScript object.

  [dir()](https://developer.mozilla.org/en-US/docs/Web/API/console/dir)
  */
  fun dir (value : a) : a {
    `console.dir(#{value})`
    value
  }

  /*
  Displays an interactive tree of the descendant elements of the specified XML/HTML
  element.

  [dirxml()](https://developer.mozilla.org/en-US/docs/Web/API/console/dirxml)
  */
  fun dirxml (value : a) : a {
    `console.dirxml(#{value})`
    value
  }

  /*
  Outputs an error message to the Web Console. Supports string substitution.

  [error()](https://developer.mozilla.org/en-US/docs/Web/API/console/error)
  */
  fun error (value : a, values : Array(b) = []) : Tuple(a, Array(b)) {
    `console.error(#{value}, ...#{values})`
    {value, values}
  }

  /*
  Creates a new inline group in the Web Console log.

  [group()](https://developer.mozilla.org/en-US/docs/Web/API/console/group)
  */
  fun group (label : String = "Default") : String {
    `console.group(#{label})`
    label
  }

  /*
  Creates a new inline group in the Web Console log. The new group is created collapsed.

  [groupCollapsed()](https://developer.mozilla.org/en-US/docs/Web/API/console/groupCollapsed)
  */
  fun groupCollapsed (label : String = "Default") : String {
    `console.groupCollapsed(#{label})`
    label
  }

  /*
  Exits the current inline group in the Web Console.

  [groupEnd()](https://developer.mozilla.org/en-US/docs/Web/API/console/groupEnd)
  */
  fun groupEnd (label : String = "Default") : String {
    `console.groupEnd(#{label})`
    label
  }

  /*
  Outputs an informational message to the Web Console. Supports string substitution.

  [info()](https://developer.mozilla.org/en-US/docs/Web/API/console/info)
  */
  fun info (value : a, values : Array(b) = []) : Tuple(a, Array(b)) {
    `console.info(#{value}, ...#{values})`
    {value, values}
  }

  /*
  Outputs a message to the Web Console. Supports string substitution.

  Console.log("Hello ", ["World", "!"]) => "Hello World!"

  [log()](https://developer.mozilla.org/en-US/docs/Web/API/console/log)
  */
  fun log (value : a, values : Array(b) = []) : Tuple(a, Array(b)) {
    `console.log(#{value}, ...#{values})`
    {value, values}
  }

  /*
  **NON-STANDARD**:

  Starts recording a performance profile.

  [profile()](https://developer.mozilla.org/en-US/docs/Web/API/console/profile)
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
  **NON-STANDARD**:

  Stops recording a performance profile previously started.

  [profileEnd()](https://developer.mozilla.org/en-US/docs/Web/API/console/profileEnd)
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
  Logs data as a table.

  [table()](https://developer.mozilla.org/en-US/docs/Web/API/console/table)
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
  Starts a timer.

  [time()](https://developer.mozilla.org/en-US/docs/Web/API/console/time)
  */
  fun time (label : String = "Default") : String {
    `console.time(#{label})`
    label
  }

  /*
  Stops a timer that was previously started.

  [timeEnd()](https://developer.mozilla.org/en-US/docs/Web/API/console/timeEnd)
  */
  fun timeEnd (label : String = "Default") : String {
    `console.timeEnd(#{label})`
    label
  }

  /*
  Logs the current value of a timer that was previously started.

  [timeLog()](https://developer.mozilla.org/en-US/docs/Web/API/console/timeLog)
  */
  fun timeLog (label : String = "Default", values : Array(a) = []) : Tuple(String, Array(a)) {
    `console.timeLog(#{label}, ...#{values})`
    {label, values}
  }

  /*
  **NON-STANDARD**:

  Adds a single marker to the browser's performance tool.

  [timestamp()](https://developer.mozilla.org/en-US/docs/Web/API/console/timestamp)
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
  Outputs a stack trace to the Web Console. Does not support string substitution.

  [trace()](https://developer.mozilla.org/en-US/docs/Web/API/console/trace)
  */
  fun trace (value : a, values : Array(b)) : Tuple(a, Array(b)) {
    `console.trace(#{value}, ...#{values})`
    {value, values}
  }

  /*
  Outputs a warning message to the Web Console.

  [warn()](https://developer.mozilla.org/en-US/docs/Web/API/console/warn)
  */
  fun warn (value : a, values : Array(b) = []) : Tuple(a, Array(b)) {
    `console.warn(#{value}, ...#{values})`
    {value, values}
  }
}
