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

// The `or` operator.
export const or = (item, value) => {
  if (item !== undefined && item !== null) {
    return item;
  } else {
    return value;
  }
};
