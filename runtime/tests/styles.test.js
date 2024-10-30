import { expect, test, describe } from "vitest";
import { style } from "../index";

describe("style", () => {
  test("it creates an object from objects and maps", () => {
    expect(
      style([
        "opacity:0;   z-index:   100   ;  ",
        new Map([["a", "b"]]),
        new Map([[101, "d"]]),
        [["x", "y"]],
        { c: "d" },
        { z: 123 },
      ]),
    ).toEqual({
      "z-index": "100",
      opacity: "0",
      a: "b",
      101: "d",
      x: "y",
      c: "d",
      z: "123",
    });
  });
});
