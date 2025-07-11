import { identity } from "./utilities";
import { Name } from "./symbols";

// Encodes `Time`
export const encodeTime = (value) => value.toISOString();

// Encodes `Array(item)`
export const encodeArray = (encoder) => (value) => {
  return value.map((item) => {
    return encoder ? encoder(item) : item;
  });
};

// Encodes `Map(String, value)` as a JS object. `Map` internally is just
// an array of key, value pairs which is an array as well.
export const encodeMap = (encoder) => (value) => {
  const result = {};

  for (let item of value) {
    result[item[0]] = encoder ? encoder(item[1]) : item[1];
  }

  return result;
};

// Encodes `Map(a, b)` as a JS array. `Map` internally is just
// an array of key, value pairs which is an array as well.
export const encodeMapArray = (keyEncoder, valueEncoder) => (value) => {
  const result = [];

  for (let item of value) {
    result.push([
      keyEncoder ? keyEncoder(item[0]) : item[0],
      valueEncoder ? valueEncoder(item[1]) : item[1],
    ]);
  }

  return result;
};

// Encodes `Maybe`. `Nothing` becomes `null`, `Just` is unwrapped.
export const encodeMaybe = (encoder, just) => (value) => {
  if (value instanceof just) {
    return encoder(value._0);
  } else {
    return null;
  }
};

// Encodes `Tuple(...)`
export const encodeTuple = (encoders) => (value) => {
  return value.map((item, index) => {
    const encoder = encoders[index];
    return encoder ? encoder(item) : item;
  });
};

// Encode a record with the encoders. An encoder can be a function or
// an array where the first item is the function the second is the key
// to use.
export const encoder = (encoders) => (value) => {
  const result = {};

  for (let key in encoders) {
    let encoder = encoders[key];
    let field = key;

    if (Array.isArray(encoder)) {
      encoder = encoders[key][0];
      field = encoders[key][1];
    }

    result[field] = (encoder || identity)(value[key]);
  }

  return result;
};

export const encodeVariant = (encoders) => (value) => {
  const variant = encoders.find((item) => value instanceof item[0]);
  const result = { type: value[Name] };

  if (variant[1]) {
    result.value = [];

    for (let index = 0; index < variant[1].length; index++) {
      result.value.push(variant[1][index](value[`_${index}`]));
    }
  }

  return result;
};
