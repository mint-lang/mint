import { expect, test, describe } from "vitest";

import { encodeVariant, identity, variant } from "../index";

const VariantRecord = variant(["name", "age"], "Record");
const VariantParams = variant(2, "Params");
const VariantEmpty = variant(0, "Empty");

const encoder = [
  [VariantRecord, [identity, identity]],
  [VariantParams, [identity, identity]],
  [VariantEmpty],
];

test("encodeVariant (simple variant)", () => {
  const encoded = encodeVariant(encoder)(new VariantEmpty());
  expect(encoded).toStrictEqual({ type: "Empty" });
});

test("encodeVariant (params variant)", () => {
  const encoded = encodeVariant(encoder)(new VariantParams("Joe", 42));
  expect(encoded).toStrictEqual({ type: "Params", value: ["Joe", 42] });
});

test("encodeVariant (record variant)", () => {
  const encoded = encodeVariant(encoder)(new VariantRecord("Joe", 42));
  expect(encoded).toStrictEqual({ type: "Record", value: ["Joe", 42] });
});
