// Creates an type variant class, this is needed so we can do proper
// comparisons and pattern matching / destructuring.
export const variant = (input) => {
  return class {
    constructor(...args) {
      if (Array.isArray(input)) {
        for (let index = 0; index < input; index++) {
          this[input[index]] = args[index];
        }
      } else {
        for (let index = 0; index < input; index++) {
          this[`_${index}`] = args[index];
        }
      }
    }
  };
};

// Creates a new variant from variable arguments.
export const newVariant = (item) => {
  return (...args) => new item(...args);
};
