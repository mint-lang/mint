import { variant, newVariant, inspect, record } from "../index_testing";
import { expect, test, describe } from "vitest";

test("inspecting null", () => {
  expect(inspect(null)).toBe("null");
});

test("inspecting undefined", () => {
  expect(inspect(undefined)).toBe("undefined");
});

test("inspecting string", () => {
  expect(inspect("Hello")).toBe(`"Hello"`);
});

test("inspecting number", () => {
  expect(inspect(0)).toBe(`0`);
});

test("inspecting boolean", () => {
  expect(inspect(true)).toBe(`true`);
});

test("inspecting boolean", () => {
  expect(inspect({props: {}, type: {}, ref: {}, key: {},"__": {}})).toBe(`VNode`);
});

test("inspecting object", () => {
  expect(inspect({ name: "Joe" })).toBe(`{ name: "Joe" }`);
});

test("inspecting element", () => {
  expect(inspect(document.createElement("div"))).toBe(`<div>`);
});

test("inspecting element", () => {
  expect(inspect(document.createElement("div"))).toBe(`<div>`);
});

test("inspecting variant", () => {
  const Test = variant(0, `Test`)
  expect(inspect(newVariant(Test)())).toBe(`Test`);
});

test("inspecting variant (with parameters)", () => {
  const Test = variant(1, `Test`)
  expect(inspect(newVariant(Test)("Hello"))).toBe(`Test("Hello")`);
});

test("inspecting variant (with named parameters)", () => {
  const Test = variant(["a", "b"], `Test`)
  expect(inspect(newVariant(Test)("Hello", "World!"))).toBe(`Test(a: "Hello", b: "World!")`);
});

test("inspecting record", () => {
  const Test = record(`Test`)
  expect(inspect(Test({ a: "Hello", b: "World!"}))).toBe(`Test { a: "Hello", b: "World!" }`);
});

test("inspecting array", () => {
  expect(inspect(["Hello", "World!"])).toBe(`["Hello", "World!"]`);
});

test("inspecting unkown", () => {
  expect(inspect(Symbol("WTF"))).toBe(`{ Symbol(WTF) }`);
});

test("inspecting nested", () => {
  expect(inspect({ a: "Hello", b: "World!", nested: { x: "With new line!\nYes!"}})).toBe(`{
  a: "Hello",
  b: "World!",
  nested: {
    x: "With new line!
    Yes!"
  }
}`);
});
