import { expect, test, describe } from "vitest";
import { setLocale, translate, locale } from "../index";

describe("setLocale", () => {
  test("setting locale", () => {
    setLocale("en");
    expect(locale.value).toEqual("en");
  });
});

describe("translate", () => {
  test("translates a key", () => {
    expect(translate("test")).toEqual("");
  });
});
