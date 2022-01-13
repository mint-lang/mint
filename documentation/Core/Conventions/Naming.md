## Naming

This section contains rules for naming functions in the standard library.

### Directional Functions

When naming functions which have a direction always use `start` end `end`.

- ✅ Do use 'start' and 'end'
- ❌ Don't use `left` and `right`

Examples:

- `String.padStart`, `String.padEnd`
- `String.chopStart`, `String.chopEnd`

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
- ❌ Don't use `includes`

- `Array.contains`, `Map.contains`
