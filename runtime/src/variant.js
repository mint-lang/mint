import { compareObjects, compare } from "./equality";
import { Equals, Name } from "./symbols";

// The base class for variants.
export class Variant {
  [Equals](other) {
    if (!(other instanceof this.constructor)) {
      return false;
    }

    if (other.length !== this.length) {
      return false;
    }

    if (this.record) {
      return compareObjects(this, other);
    }

    for (let index = 0; index < this.length; index++) {
      if (!compare(this["_" + index], other["_" + index])) {
        return false;
      }
    }

    return true;
  }
}

// Creates an type variant class, this is needed so we can do proper
// comparisons and pattern matching / destructuring.
export const variant = (input, name) => {
  return class extends Variant {
    constructor(...args) {
      super();
      this[Name] = name;
      if (Array.isArray(input)) {
        this.length = input.length;
        this.record = true;

        for (let index = 0; index < input.length; index++) {
          this[input[index]] = args[index];
          this[`_${index}`] = args[index];
        }
      } else {
        this.length = input;

        for (let index = 0; index < input; index++) {
          this[`_${index}`] = args[index];
        }
      }
    }
  };
};

// Creates a new variant from variable arguments.
export const newVariant =
  (item) =>
  (...args) =>
    new item(...args);
