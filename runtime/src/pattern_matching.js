import { compare } from "./equality";

// This is a pattern for destructuring types.
class Pattern {
  constructor(variant, pattern) {
    this.pattern = pattern;
    this.variant = variant;
  }
}

class PatternRecord {
  constructor(patterns) {
    this.patterns = patterns;
  }
}

class PatternMany {
  constructor(patterns) {
    this.patterns = patterns;
  }
}

// Export functions for creating various patterns.
export const pattern = (variant, pattern) => new Pattern(variant, pattern);
export const patternRecord = (patterns) => new PatternRecord(patterns);
export const patternMany = (patterns) => new PatternMany(patterns);

// Symbols to use during pattern matching.
export const patternVariable = Symbol("Variable");
export const patternSpread = Symbol("Spread");

// Destructures the value using the pattern and returns the matched values of
// the pattern as an array. If the value cannot be destructured it returns
// `false`. This is a recursive function.
export const destructure = (value, pattern, values = []) => {
  // If the pattern is null it means that we skip this value.
  if (pattern === null) {
    // This branch matches a variable in the pattern
  } else if (pattern === patternVariable) {
    values.push(value);
    // This branch covers tuples and arrays (they are the same)
  } else if (Array.isArray(pattern)) {
    const hasSpread = pattern.some((item) => item === patternSpread);

    // If we have spreads and the arrays length is bigger then the patterns
    // length that means that there will be values in the spread.
    if (hasSpread && value.length >= pattern.length - 1) {
      let startIndex = 0;
      let endValues = [];
      let endIndex = 1;

      // This destructures the head patterns until a spread (if any).
      while (
        pattern[startIndex] !== patternSpread &&
        startIndex < pattern.length
      ) {
        if (!destructure(value[startIndex], pattern[startIndex], values)) {
          return false;
        }
        startIndex++;
      }

      // This destructures the tail patterns backwards until a spread (if any).
      while (
        pattern[pattern.length - endIndex] !== patternSpread &&
        endIndex < pattern.length
      ) {
        if (
          !destructure(
            value[value.length - endIndex],
            pattern[pattern.length - endIndex],
            endValues,
          )
        ) {
          return false;
        }
        endIndex++;
      }

      // Add in the spread
      values.push(value.slice(startIndex, value.length - (endIndex - 1)));

      // Add in the end values
      for (let item of endValues) {
        values.push(item);
      }
      // This branch is for without spreads. We can only destructure patterns
      // which have the same length.
    } else {
      if (pattern.length !== value.length) {
        return false;
      } else {
        for (let index in pattern) {
          if (!destructure(value[index], pattern[index], values)) {
            return false;
          }
        }
      }
    }
    // This branch covers type variants.
  } else if (pattern instanceof Pattern) {
    if (value instanceof pattern.variant) {
      for (let index in pattern.pattern) {
        if (!destructure(value[`_${index}`], pattern.pattern[index], values)) {
          return false;
        }
      }
    } else {
      return false;
    }
  } else if (pattern instanceof PatternRecord) {
    for (let key in pattern.patterns) {
      if (!destructure(value[key], pattern.patterns[key], values)) {
        return false;
      }
    }
  } else if (pattern instanceof PatternMany) {
    // This branch is the exact opposite of the other branches since
    // we return after if one of the patterns match. If none matched
    // we return false.

    for (let item of pattern.patterns) {
      if (destructure(value, item, values)) {
        return values;
      }
    }

    return false;
  } else {
    if (!compare(value, pattern)) {
      return false;
    }
  }

  return values;
};

// Matches a value with different patterns and calls the function of the first
// matching pattern.
//
//   match("Hello", [
//     ["World", () => "It's world"],
//     [patternVariable, (value) => value] // This is matched
//   ])
//
export const match = (value, branches) => {
  for (let branch of branches) {
    if (branch[0] === null) {
      return branch[1]();
    } else {
      const values = destructure(value, branch[0]);

      if (values) {
        return branch[1].apply(null, values);
      }
    }
  }
};
