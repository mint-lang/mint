## Naming

This section contains rules for naming functions in the standard library.

### Directional Functions

When naming functions which have a direction always use `start` end `end`.

- ✅ Do use 'start' and 'end'
- ❌ Don't use `left` and `right`

Examples:

- `String.padStart`, `String.padEnd`
- `String.chopStart`, `String.chopEnd`

### First

When referencing the first element in an enumerable entity:

- ✅ Do use `first`
- ❌ Don't use `head`

### Empty and Blank

We distinguish between empty and blank states:

- Use `isEmpty` for testing that the data doesn't contain anything
- Use `isBlank` for testing it the data seemingly doesn't contain anything

Examples:

- `String.isEmpty`, `Html.isEmpty`
- `String.isBlank`

### Inclusiveness

To check if something has something else use `contains`.

- ✅ Use `contains`
- ❌ Don't use `includes`, `has`

- `Array.contains`, `Map.contains`

### Removal of Items

- ✅ Use `delete`
- ❌ Don't use `remove`

### Size

- ✅ Use `size`
- ❌ Don't use `length`

### Function Paramters

- ✅ Use `function` as the parameter name for functions that take a function:

  ```
  fun any (function : Function(item, Bool), array : Array(item))
  ```

### Type Variables

- ✅ Use descriptive names like `item`, `string`, `number`, `index`
- ❌ Don't use single letter type variables `a`, `b`, `c`
