import { variant, compare, newVariant } from "../index";
import { expect, test, describe } from "vitest";

const RecordEnum = variant(["a", "b"]);
const TestEnum2 = variant(2);
const TestEnum = variant(0);

describe("equality", () => {
  test("same instance equals true", () => {
    expect(compare(new TestEnum(), new TestEnum())).toEqual(true);
  });

  test("same parameters equals true", () => {
    expect(compare(new TestEnum2("0", "1"), new TestEnum2("0", "1"))).toEqual(
      true,
    );
  });

  test("different instances equals false", () => {
    expect(compare(new TestEnum2("0", "2"), new TestEnum())).toEqual(false);
  });

  test("different lengths equals false", () => {
    const a = new TestEnum2("0", "2");
    const b = new TestEnum2("0", "2");
    b.length = 10;

    expect(compare(a, b)).toEqual(false);
  });

  test("different parameters equals false", () => {
    expect(compare(new TestEnum2("0", "2"), new TestEnum2("0", "1"))).toEqual(
      false,
    );
  });

  test("same enum equals true", () => {
    expect(
      compare(
        newVariant(RecordEnum)("a", "b"),
        newVariant(RecordEnum)("a", "b"),
      ),
    ).toEqual(true);
  });

  test("different enum equals false", () => {
    expect(
      compare(
        newVariant(RecordEnum)("a", "b"),
        newVariant(RecordEnum)("a", "c"),
      ),
    ).toEqual(false);
  });
});
