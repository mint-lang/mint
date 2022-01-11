## Modules

This section contains rules for modules.

### Entity Order

1. Constants
2. Functions Alphabetically

### Comments

The modules should have a comment before it describing what it is for and
giving some examples.

All functions should have a comment before them describing what the function
does and a code block showing an example or test case.

## Naming

This section contains rules for naming functions in the standard library.

### Directional Functions

When naming functions which have a direction always use `start` end `end`.

- ✅ Do use 'start' and 'end'
- ❌ Don't use `left` and `right`

### Empty and Blank

We distinguish between empty and blank states:

- Use `isEmpty` for testing that the data doesn't contain anything
- Use `isBlank` for testing it the data seemingly doesn't contain anything

### Inclusiveness

To check if something has something else use `contains`.

- ✅ Use `contains`
- ❌ Don't use `includes`
