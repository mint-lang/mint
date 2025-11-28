import { signal, useSignalEffect, useSignal as useSignalOriginal } from "@preact/signals";
import { useEffect, useRef, useMemo, useCallback } from "preact/hooks";

import {
  createRef as createRefOriginal,
  createElement,
  Component,
} from "preact";

import { compare } from "./equality";
import { Name } from "./symbols";

// This finds the first element matching the key in a map ([[key, value]]).
export const mapAccess = (map, key, just, nothing) => {
  for (const item of map) {
    if (compare(item[0], key)) {
      return new just(item[1]);
    }
  }

  return new nothing();
};

// We need to have a different function for accessing array items because there
// is no concept of `null` in Mint so we return `Just(a)` or `Nothing`.
export const bracketAccess = (array, index, just, nothing) => {
  if (array.length >= index + 1 && index >= 0) {
    return new just(array[index]);
  } else {
    return new nothing();
  }
};

// These set the references to an element or component. The current
// value is always a `Maybe`
export const setTestRef = (signal, just, nothing) => (element) => {
  let current;
  if (element === null) {
    current = new nothing();
  } else {
    current = new just(element);
  }

  if (signal) {
    if (!compare(signal.peek(), current)) {
      signal.value = current
    }
  }
}

export const setRef = (signal, just, nothing) => {
  return useCallback((element) => {
    setTestRef(signal, just, nothing)(element)
  }, [])
};

// The normal useSignal.
export const useRefSignal = useSignalOriginal;

// A version of `useSignal` which subscribes to the signal by default (like a
// state) since we want to re-render every time the signal changes.
export const useSignal = (value) => {
  const item = useMemo(() => signal(value), []);
  item.value;
  return item;
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

// Creates an instrumented object so we know which record it belongs to.
export const record = (name) => (value) => ({ [Name]: name, ...value });

// A component to lazy load another component.
export class lazyComponent extends Component {
  async componentDidMount() {
    let x = await this.props.x();
    this.setState({ x: x });
  }

  render() {
    if (this.state.x) {
      return createElement(this.state.x, this.props.p, this.props.c);
    } else {
      if (this.props.f) {
        return this.props.f();
      } else {
        return null;
      }
    }
  }
}

// A higher order function to lazy load a module.
export const lazy = (path) => async () => load(path);

// Loads load a module.
export const load = async (path) => {
  const x = await import(path);
  return x.default;
};

// Returns true for just and ok.
export const isThruthy = (value, just, ok) => {
  return value instanceof ok || value instanceof just
};

// Returns a signal for tracking the size of an entity.
export const useDimensions = (ref, get, just, nothing) => {
  const signal = useSignal(new nothing);

  // Initial setup...
  useSignalEffect(() => {
    const observer = new ResizeObserver(() => {
      signal.value = ref.value && ref.value._0 ? new just(get(ref.value._0)) : new nothing;
    });

    if (ref.value && ref.value._0) {
      observer.observe(ref.value._0);
    }

    return () => {
      signal.value = new nothing;
      observer.disconnect();
    };
  });

  return signal;
}
