import indentString from "indent-string";
import { isVnode } from './equality';
import { Variant } from './variant';
import { Name } from './symbols';

const render = (items, prefix, suffix, fn) => {
  items =
    items.map(fn);

  const newLines =
    items.size > 3 || items.filter((item) => item.indexOf("\n") > 0).length;

  const joined =
    items.join(newLines ? ",\n" : ", ");

  if (newLines) {
    return `${prefix.trim()}\n${indentString(joined, 2)}\n${suffix.trim()}`;
  } else {
    return `${prefix}${joined}${suffix}`;
  }
}

const toString = (object) => {
  if (object.type === "null") {
    return "null";
  } else if (object.type === "undefined") {
    return "undefined";
  } else if (object.type === "string") {
    return `"${object.value}"`;
  } else if (object.type === "number") {
    return `${object.value}`;
  } else if (object.type === "boolean") {
    return `${object.value}`;
  } else if (object.type === "element") {
    return `<${object.value.toLowerCase()}>`
  } else if (object.type === "variant") {
    if (object.items) {
      return render(object.items, `${object.value}(`, `)`, toString);
    } else {
      return object.value;
    }
  } else if (object.type === "array") {
    return render(object.items, `[`, `]`, toString);
  } else if (object.type === "object") {
    return render(object.items, `{ `, ` }`, toString);
  } else if (object.type === "record") {
    return render(object.items, `${object.value} { `, ` }`, toString);
  } else if (object.type === "unknown") {
    return `{ ${object.value} }`;
  } else if (object.type === "vnode") {
    return `VNode`;
  } else if (object.key) {
    return `${object.key}: ${toString(object.value)}`;
  } else if (object.value) {
    return toString(object.value);
  }
}

const objectify = (value) => {
  if (value === null) {
    return { type: "null" };
  } else if (value === undefined) {
    return { type: "undefined" };
  } else if (typeof value === "string") {
    return { type: "string", value: value };
  } else if (typeof value === "number") {
    return { type: "number", value: value.toString() };
  } else if (typeof value === "boolean") {
    return { type: "boolean", value: value.toString() };
  } else if (value instanceof HTMLElement) {
    return { type: "element", value: value.tagName };
  } else if (value instanceof Variant) {
    const items = [];

    if (value.record) {
      for (const key in value) {
        if (key === "length" || key === "record" || key.startsWith("_")) {
          continue;
        };

        items.push({
          value: objectify(value[key]),
          key: key
        });
      }
    } else {
      for (let i = 0; i < value.length; i++) {
        items.push({
          value: objectify(value[`_${i}`])
        });
      };
    }

    if (items.length) {
      return { type: "variant", value: value[Name], items: items };
    } else {
      return { type: "variant", value: value[Name] };
    }
  } else if (Array.isArray(value)) {
    return {
      items: value.map((item) => ({ value: objectify(item) })),
      type: "array"
    };
  } else if (isVnode(value)) {
    return { type: "vnode" }
  } else if (typeof value == "object") {
    const items = [];

    for (const key in value) {
      items.push({
        value: objectify(value[key]),
        key: key
      });
    };

    if (Name in value) {
      return { type: "record",  value: value[Name], items: items };
    } else {
      return { type: "object", items: items };
    }
  } else {
    return { type: "unknown", value: value.toString() };
  }
}

export const inspect = (value) => {
  return toString(objectify(value))
}
