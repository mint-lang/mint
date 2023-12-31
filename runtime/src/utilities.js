import { useEffect } from "preact/hooks";

// We need to have a different function for accessing array items because there
// is no concept of `null` in Mint so we return `Just(a)` or `Nothing`.
export const arrayAccess = (array, index, just, nothing) => {
  if (array.length >= index + 1 && index >= 0) {
    return new just(array[index]);
  } else {
    return new nothing();
  }
};

// A hook to replace the `componentDidUpdate` function.
export const useDidUpdate = (callback) => {
  const hasMount = useRef(false);

  useEffect(() => {
    if (hasMount.current) {
      callback();
    } else {
      hasMount.current = true;
    }
  });
};

// Function for the `or` operator.
export const or = (item, value) => {
  if (item !== undefined && item !== null) {
    return item;
  } else {
    return value;
  }
};

// Converts the arguments into an array.
export const toArray = (...args) => {
  let items = Array.from(args);
  if (Array.isArray(items[0]) && items.length === 1) {
    return items[0];
  } else {
    return items;
  }
};

// Function for member access.
export const access = (field) => (value) => value[field];

// Identity function used in encoders.
export const identity = (a) => a;
