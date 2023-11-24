// This file contains code to have value equality instead of reference equality.
// We use a `Symbol` to have a custom equality functions and then use these
// functions when comparing two values.

const Equals = Symbol("Equals");

Boolean.prototype[Equals] =
  Symbol.prototype[Equals] =
  Number.prototype[Equals] =
  String.prototype[Equals] =
    function (other) {
      return this.valueOf() === other;
    };

Date.prototype[Equals] = function (other) {
  return +this === +other;
};

Function.prototype[Equals] = Node.prototype[Equals] = function (other) {
  return this === other;
};

// Search parameters need to be the same string to be equal.
URLSearchParams.prototype[Equals] = function (other) {
  if (other === null || other === undefined) {
    return false;
  }

  return this.toString() === other.toString();
};

// Sets need to have the same elements to be equal.
Set.prototype[Equals] = function (other) {
  if (other === null || other === undefined) {
    return false;
  }

  return compare(Array.from(this).sort(), Array.from(other).sort());
};

// Arrays need to have the same elements to be equal.
Array.prototype[Equals] = function (other) {
  if (other === null || other === undefined) {
    return false;
  }
  if (this.length !== other.length) {
    return false;
  }
  if (this.length == 0) {
    return true;
  }

  for (let index in this) {
    if (!compare(this[index], other[index])) {
      return false;
    }
  }

  return true;
};

// Form data need to have the same elements to be equal.
FormData.prototype[Equals] = function (other) {
  if (other === null || other === undefined) {
    return false;
  }

  const bKeys = Array.from(other.keys()).sort();
  const aKeys = Array.from(this.keys()).sort();

  if (compare(aKeys, bKeys)) {
    if (aKeys.length == 0) {
      return true;
    }

    for (let key of aKeys) {
      const bValue = Array.from(other.getAll(key).sort());
      const aValue = Array.from(this.getAll(key).sort());

      if (!compare(aValue, bValue)) {
        return false;
      }
    }

    return true;
  } else {
    return false;
  }
};

// This is the custom comparison function.
export const compare = (a, b) => {
  if ((a === undefined && b === undefined) || (a === null && b === null)) {
    return true;
  } else if (a != null && a != undefined && a[Equals]) {
    return a[Equals](b);
  } else if (b != null && b != undefined && b[Equals]) {
    return b[Equals](a);
  } else {
    return compareObjects(a, b);
  }
};

// This is the custom comparison function for plain objects.
export const compareObjects = (a, b) => {
  if (a instanceof Object && b instanceof Object) {
    const keys = new Set(Object.keys(a).concat(Object.keys(b)));

    for (let key of keys) {
      if (!compare(a[key], b[key])) {
        return false;
      }
    }

    return true;
  } else {
    // We fall back to strict equality if there is something we don't know
    // how to compare.
    return a === b;
  }
};
