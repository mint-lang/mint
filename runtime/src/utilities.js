import { createRef as createRefOriginal, Component, createElement } from "preact";
import { useEffect, useRef, useMemo } from "preact/hooks";
import { signal } from "@preact/signals";

import { compare } from "./equality";

// This finds the first element matching the key in a map ([[key, value]]).
export const mapAccess = (map, key, just, nothing) => {
  for (const item of map) {
    if (compare(item[0], key)) {
      return new just(item[1])
    }
  }

  return new nothing();
}

// We need to have a different function for accessing array items because there
// is no concept of `null` in Mint so we return `Just(a)` or `Nothing`.
export const bracketAccess = (array, index, just, nothing) => {
  if (array.length >= index + 1 && index >= 0) {
    return new just(array[index]);
  } else {
    return new nothing();
  }
};

// This sets the references to an element or component. The current
// value is always a `Maybe`
export const setRef = (value, just) => (element) => {
  if (value.current._0 !== element) {
    value.current = new just(element);
  }
};

// A version of `useSignal`` which subscribes to the signal by default (like a
// state) since we want to re-render every time the signal changes.
export const useSignal = (value) => {
  const item = useMemo(() => signal(value), []);
  item.value;
  return item;
};

// A version of `createRef` with a default value.
export const createRef = (value) => {
  const ref = createRefOriginal();
  ref.current = value;
  return ref;
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
export const or = (nothing, err, item, value) => {
  if (item instanceof nothing || item instanceof err) {
    return value;
  } else {
    return item._0;
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

// Identity function, used in encoders.
export const identity = (a) => a;

export class lazyComponent extends Component {
  async componentDidMount() {
    let x = await this.props.x();
    this.setState({ x: x })
  }

  render() {
    if (this.state.x) {
      return createElement(this.state.x, this.props.p, this.props.c)
    } else {
      return null
    }
  }
}

export const lazy = (path) => async () => load(path)

export const load = async (path) => {
  const x = await import(path)
  return x.default
}
