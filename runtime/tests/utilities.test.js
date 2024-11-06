import { render, fireEvent } from "@testing-library/preact";
import { expect, test, describe } from "vitest";
import { useState } from "preact/hooks";
import { h } from "preact";

import {
  useDidUpdate,
  bracketAccess,
  useFunction,
  identity,
  variant,
  toArray,
  access,
  or,
} from "../index";

const Nothing = variant();
const Just = variant(1);
const Err = variant(1);

describe("bracketAccess", () => {
  test("it returns a just for an element", () => {
    let result = bracketAccess([0], 0, Just, Nothing);

    expect(result).toBeInstanceOf(Just);
    expect(result._0).toBe(0);
  });

  test("it returns nothing for an element", () => {
    let result = bracketAccess([0], 1, Just, Nothing);

    expect(result).toBeInstanceOf(Nothing);
  });

  test("it returns nothing if index is negative", () => {
    let result = bracketAccess([0], -1, Just, Nothing);

    expect(result).toBeInstanceOf(Nothing);
  });
});

describe("or", () => {
  test("it returns the given item", () => {
    expect(or(Nothing, Err, new Just("a"), "b")).toEqual("a");
  });

  test("it returns the given item", () => {
    expect(or(Nothing, Err, new Nothing, "b")).toEqual("b");
  });
});

describe("access", () => {
  test("it returns the field", () => {
    expect(access("a")({ a: "b" })).toEqual("b");
  });
});

describe("identity", () => {
  test("it returns the value", () => {
    expect(identity("a")).toEqual("a");
  });
});

describe("toArray", () => {
  test("it returns an array for not arrays", () => {
    expect(toArray(0)).toEqual([0]);
  });

  test("returns the input array for an arrays", () => {
    expect(toArray([0])).toEqual([0]);
  });
});

describe("useDidUpdate", () => {
  test("calls on changes", () => {
    const item = h(() => {
      useDidUpdate(() => {});
      const [count, setCount] = useState(0);
      return h("div", { onClick: () => setCount(1) }, "TEST");
    });

    const container = render(item);
    fireEvent.click(container.getByText("TEST"));
  });
});
