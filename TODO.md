# TODO

## Documentation

### Type System

In Mint the types and type definitions are only for the type checker and
compiler, they are not available or used by the runtime.

Because of that types can be defined in any type definition (except Records and
Enums), so for example if Time is not defined as an Enum or Record when
writing this:

```mint
module Time {
  fun now : Time {
  ...
  }
}
```

will define Time as a type.

Since only this function defines this as a return type we can safely use the
same type in type signatures of other functions:

```mint
fun day (date : Time ) : Number {...}
fun format (pattern : String, date : Time) : String {...}
```

because the Time.now() is the only place values of Time can come from.

I don't know what to call this but it's used all over the standard library, from
Set(a), Map(a) and even Array(a) is defined this way, also this is how it
works in Elm.

## Core Modules

### Time Module

Refactor from scratch with inspiration from:

- https://momentjs.com/
- https://package.elm-lang.org/packages/elm/time/1.0.0/
- https://github.com/iamkun/dayjs
- https://github.com/Teamweek/instadate
