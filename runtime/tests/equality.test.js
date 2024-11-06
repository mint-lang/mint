import { expect, test, describe } from "vitest";
import { compare } from "../index_testing";

test("comparing nulls", () => {
  expect(compare(null, null)).toBe(true);
  expect(compare(null, undefined)).toBe(false);
  expect(compare(undefined, "")).toBe(false);
});

test("comparing nodes", () => {
  expect(compare(document.body, document.body)).toBe(true);
  expect(compare(document.body, document.head)).toBe(false);
});

test("comparing same symbols", () => {
  expect(compare(Symbol("A"), Symbol("A"))).toBe(false);
});

test("comparing vnodes", () => {
  expect(compare(
    {props: {}, type: {}, ref: {}, key: {},"__": {}},
    {props: {}, type: {}, ref: {}, key: {},"__": {}}
  )).toBe(false);
})

test("comparing same arrays", () => {
  expect(["A"] == ["A"]).toBe(false);
  expect(compare(["A"], ["A"])).toBe(true);
});

test("comparing functions", () => {
  expect(
    compare(
      () => {},
      () => {},
    ),
  ).toBe(false);
});

test("comparing empty arrays", () => {
  expect([] == []).toBe(false);
  expect(compare([], [])).toBe(true);
});

test("comparing arrays with null", () => {
  expect(compare([], null)).toBe(false);
});

test("comparing arrays with undefined", () => {
  expect(compare([], undefined)).toBe(false);
});

test("comparing different length arrays", () => {
  expect(["A"] == ["A"]).toBe(false);
  expect(compare(["A", "B"], ["A"])).toBe(false);
});

test("comparing different arrays", () => {
  expect(compare(["A"], ["B"])).toBe(false);
});

test("comparing same dates", () => {
  expect(new Date() == new Date()).toBe(false);
  expect(compare(new Date(), new Date())).toBe(true);
});

test("comparing different dates", () => {
  expect(compare(new Date(2018, 1, 1), new Date(2018, 1, 2))).toBe(false);
});

test("comparing same strings", () => {
  expect(compare("A", "A")).toBe(true);
});

test("comparing same numbers", () => {
  expect(compare(0, 0.0)).toBe(true);
});

test("comparing booleans", () => {
  expect(compare(true, true)).toBe(true);
});

test("comparing objects", () => {
  expect(compare({ a: "a" }, { a: "a" })).toBe(true);
  expect(compare({ a: "a" }, { a: "b" })).toBe(false);
  expect(compare({ a: "a" }, { a: "a", b: "c" })).toBe(false);
});

describe("URLSearchParams", () => {
  test("false for null", () => {
    const a = new URLSearchParams("a=b&c=d");

    expect(compare(a, null)).toBe(false);
  });

  test("false for undefined", () => {
    const a = new URLSearchParams("a=b&c=d");

    expect(compare(a, undefined)).toBe(false);
  });

  test("same data are equal", () => {
    const a = new URLSearchParams("a=b&c=d");
    const b = new URLSearchParams("a=b&c=d");

    expect(compare(a, b)).toBe(true);
  });
});

describe("Map", () => {
  test("false for undefined", () => {
    const a = new Map();

    expect(compare(a, undefined)).toBe(false);
  });

  test("false for null", () => {
    const a = new Map();

    expect(compare(a, null)).toBe(false);
  });

  test("same data are equal", () => {
    const a = new Map([
      ["A", "B"],
      ["X", "Y"],
    ]);
    const b = new Map([
      ["A", "B"],
      ["X", "Y"],
    ]);

    expect(compare(a, b)).toBe(true);
  });

  test("same data with different order are equal", () => {
    const a = new Map([
      ["X", "Y"],
      ["A", "B"],
    ]);
    const b = new Map([
      ["A", "B"],
      ["X", "Y"],
    ]);

    expect(compare(a, b)).toBe(true);
  });

  test("empty maps are equal", () => {
    const a = new Map();
    const b = new Map();

    expect(compare(a, b)).toBe(true);
  });

  test("different data are not equal", () => {
    const a = new Map([
      ["A", "B"],
      ["X", "Z"],
    ]);
    const b = new Map([
      ["A", "B"],
      ["X", "Y"],
    ]);

    expect(compare(a, b)).toBe(false);
  });

  test("data with different number of keys are not equal", () => {
    const a = new Map([["A", "B"]]);
    const b = new Map([
      ["A", "B"],
      ["X", "Y"],
    ]);

    expect(compare(a, b)).toBe(false);
  });
});

describe("Set", () => {
  test("false for undefined", () => {
    const a = new Set([]);

    expect(compare(a, undefined)).toBe(false);
  });

  test("false for null", () => {
    const a = new Set([]);

    expect(compare(a, null)).toBe(false);
  });

  test("same data are equal", () => {
    const a = new Set(["A", "B", "B"]);
    const b = new Set(["A", "B", "B"]);

    expect(compare(a, b)).toBe(true);
  });

  test("same data not in order are equal", () => {
    const a = new Set(["B", "A", "A"]);
    const b = new Set(["A", "B", "B"]);

    expect(compare(a, b)).toBe(true);
  });

  test("different data does not equal", () => {
    const a = new Set(["B", "C", "A"]);
    const b = new Set(["A", "B", "B"]);

    expect(compare(a, b)).toBe(false);
  });
});

describe("FormData", () => {
  test("false for undefined", () => {
    const a = new FormData();

    expect(compare(a, undefined)).toBe(false);
  });

  test("false for null", () => {
    const a = new FormData();

    expect(compare(a, null)).toBe(false);
  });

  test("empty form datas are equal", () => {
    expect(compare(new FormData(), new FormData())).toBe(true);
  });

  test("same data form datas are equal", () => {
    const a = new FormData();
    a.append("a", "a");

    const b = new FormData();
    b.append("a", "a");

    expect(compare(a, b)).toBe(true);
  });

  test("different datas are not equal", () => {
    const a = new FormData();
    a.append("a", "a");

    const b = new FormData();
    b.append("b", "a");

    expect(compare(a, b)).toBe(false);
  });

  test("different datas are not equal", () => {
    const a = new FormData();
    a.append("a", "b");

    const b = new FormData();
    b.append("a", "a");

    expect(compare(a, b)).toBe(false);
  });

  test("same multiple data form datas are equal", () => {
    const a = new FormData();
    a.append("a", "a");
    a.append("a", "b");

    const b = new FormData();
    b.append("a", "b");
    b.append("a", "a");

    expect(compare(a, b)).toBe(true);
  });

  test("same multiple data form datas with different order are equal", () => {
    const a = new FormData();
    a.append("a", "b");
    a.append("x", "y");

    const b = new FormData();
    b.append("x", "y");
    b.append("a", "b");

    expect(compare(a, b)).toBe(true);
  });
});
