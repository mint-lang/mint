import { expect, test, describe } from "vitest";

import {
  decodeVariant,
  decodeBoolean,
  decodeString,
  decodeNumber,
  decodeObject,
  decodeField,
  decodeMaybe,
  decodeTuple,
  decodeArray,
  decodeTime,
  decodeType,
  decodeMap,
  decoder,
  variant,
} from "../index";

import { Name } from "../src/symbols";

const Nothing = variant(0, "Nothing");
const Just = variant(1, "Just");
const Err = variant(1, "Err");
const Ok = variant(1, "Ok");

const VariantRecord = variant(["name", "age"], "Record");
const VariantParams = variant(2, "Params");
const VariantEmpty = variant(0, "Empty");

const Test = decodeType(
  "Test",
  {
    Params: decodeVariant(
      VariantParams,
      [decodeString(Ok, Err), decodeNumber(Ok, Err)],
      Ok,
      Err,
    ),
    Record: decodeVariant(
      VariantRecord,
      [decodeString(Ok, Err), decodeNumber(Ok, Err)],
      Ok,
      Err,
    ),
    Empty: decodeVariant(VariantEmpty, null, Ok, Err),
  },
  Ok,
  Err,
);

test("FAIL decodeType (no variant)", () => {
  const decoded = Test({ type: 0 });

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  0

as a String, but could not.

The input is in this object:

  {
    "type": 0
  }

at: type
`.trim(),
  );
});

test("FAIL decodeType (no variant)", () => {
  const decoded = Test({ type: "Blah" });

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
Invalid type Blah for type: Test
`.trim(),
  );
});

test("OK decodeType (empty variant)", () => {
  const decoded = Test({ type: "Empty" });

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toBeInstanceOf(VariantEmpty);
});

test("OK decodeType (params variant)", () => {
  const decoded = Test({ type: "Params", value: ["Hello World", 100] });

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toBeInstanceOf(VariantParams);
  expect(decoded._0._0).toBe("Hello World");
  expect(decoded._0._1).toBe(100);
});

test("FAIL decodeType (params variant)", () => {
  const decoded = Test({ type: "Params", value: [0, 100] });

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  0

as a String, but could not.

The input is in this object:

  [
    0,
    100
  ]

at: [0]
`.trim(),
  );
});

test("OK decodeType (record variant)", () => {
  const decoded = Test({ type: "Record", value: ["Joe", 100] });

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toBeInstanceOf(VariantRecord);
  expect(decoded._0._0).toBe("Joe");
  expect(decoded._0._1).toBe(100);
  expect(decoded._0.name).toBe("Joe");
  expect(decoded._0.age).toBe(100);
});

test("FAIL decodeType (params variant)", () => {
  const decoded = Test({ type: "Record", value: [true, 100] });

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  true

as a String, but could not.

The input is in this object:

  [
    true,
    100
  ]

at: [0]
`.trim(),
  );
});

test("OK decodeTuple", () => {
  const decoded = decodeTuple(
    [decodeString(Ok, Err), decodeNumber(Ok, Err)],
    Ok,
    Err,
  )(["Hello", 30]);

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0[0]).toBe("Hello");
  expect(decoded._0[1]).toBe(30);
});

test("FAIL decodeTuple", () => {
  const decoded = decodeTuple(
    [decodeString(Ok, Err), decodeNumber(Ok, Err)],
    Ok,
    Err,
  )("Blah");

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  "Blah"

as an Tuple, but could not.
`.trim(),
  );
});

test("FAIL decodeTuple (missing item)", () => {
  const decoded = decodeTuple(
    [decodeString(Ok, Err), decodeNumber(Ok, Err)],
    Ok,
    Err,
  )(["Hello"]);

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode one of the values of a tuple at index 1:

  undefined

but could not.
`.trim(),
  );
});

test("FAIL decodeTuple (nested decode fail)", () => {
  const decoded = decodeTuple([decodeString(Ok, Err)], Ok, Err)([0]);

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  0

as a String, but could not.

The input is in this object:

  [
    0
  ]

at: [0]
`.trim(),
  );
});

test("OK decodeArray", () => {
  const decoded = decodeArray(decodeString(Ok, Err), Ok, Err)(["Hello"]);

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0[0]).toBe("Hello");
});

test("FAIL decodeArray (not array)", () => {
  const decoded = decodeArray(decodeString(Ok, Err), Ok, Err)("Blah");

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  "Blah"

as an Array, but could not.
`.trim(),
  );
});

test("FAIL decodeArray (nested decode fail)", () => {
  const decoded = decodeArray(decodeString(Ok, Err), Ok, Err)([0]);

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  0

as a String, but could not.

The input is in this object:

  [
    0
  ]

at: [0]
`.trim(),
  );
});

test("OK decodeTime (number)", () => {
  const decoded = decodeTime(Ok, Err)(100);

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toBeInstanceOf(Date);
});

test("OK decodeTime (string)", () => {
  const decoded = decodeTime(Ok, Err)("2024-01-01");

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toBeInstanceOf(Date);
});

test("FAIL decodeTime", () => {
  const decoded = decodeTime(Ok, Err)("Blah");

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  "Blah"

as a Time, but could not.
`.trim(),
  );
});

test("OK decodeNumber", () => {
  const decoded = decodeNumber(Ok, Err)(0);

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toBe(0);
});

test("FAIL decodeNumber", () => {
  const decoded = decodeNumber(Ok, Err)("Blah");

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  "Blah"

as a Number, but could not.
`.trim(),
  );
});

test("OK decodeBoolean", () => {
  const decoded = decodeBoolean(Ok, Err)(true);

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toBe(true);
});

test("FAIL decodeBoolean", () => {
  const decoded = decodeBoolean(Ok, Err)("Blah");

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  "Blah"

as a Bool, but could not.
`.trim(),
  );
});

test("OK decodeField", () => {
  const decoded = decodeField("a", decodeString(Ok, Err), Err)({ a: "Hello" });

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toBe("Hello");
});

test("FAIL decodeField (not an object)", () => {
  const decoded = decodeField("a", decodeString(Ok, Err), Err)(null);

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the field "a" from the object:

  null

but I could not because it's not an object.
`.trim(),
  );
});

test("FAIL decodeField (nested decode fail)", () => {
  const decoded = decodeField("a", decodeString(Ok, Err), Err)({ a: 0 });

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  0

as a String, but could not.

The input is in this object:

  {
    "a": 0
  }

at: a
`.trim(),
  );
});

test("FAIL nested decodeField (nested decode fail)", () => {
  const decoded = decodeField(
    "a",
    decodeField("a", decodeString(Ok, Err), Err),
    Err,
  )({ a: { a: 0 } });

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  0

as a String, but could not.

The input is in this object:

  {
    "a": {
      "a": 0
    }
  }

at: a.a
`.trim(),
  );
});

test("FAIL nested decodeField (nested decode fail)", () => {
  const decoded = decodeField(
    "a",
    decodeArray(decodeString(Ok, Err), Ok, Err),
    Err,
  )({ a: [0] });

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  0

as a String, but could not.

The input is in this object:

  {
    "a": [
      0
    ]
  }

at: a[0]
`.trim(),
  );
});

test("OK decodeMaybe (null or undefined)", () => {
  const decoded = decodeMaybe(
    decodeString(Ok, Err),
    Ok,
    Err,
    Just,
    Nothing,
  )(undefined);

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toBeInstanceOf(Nothing);
});

test("OK decodeMaybe", () => {
  const decoded = decodeMaybe(
    decodeString(Ok, Err),
    Ok,
    Err,
    Just,
    Nothing,
  )("Hello");

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toBeInstanceOf(Just);
  expect(decoded._0._0).toBe("Hello");
});

test("FAIL decodeMaybe (nested decode fail)", () => {
  const decoded = decodeMaybe(decodeString(Ok, Err), Ok, Err, Just, Nothing)(0);

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  0

as a String, but could not.
`.trim(),
  );
});

test("OK decodeMap", () => {
  const decoded = decodeMap(decodeString(Ok, Err), Ok, Err)({ key: "value" });

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toStrictEqual([["key", "value"]]);
});

test("FAIL decodeMap (nested decode fail)", () => {
  const decoded = decodeMap(decodeString(Ok, Err), Ok, Err)({ key: 0 });

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  0

as a String, but could not.
`.trim(),
  );
});

test("FAIL decodeMap", () => {
  const decoded = decodeMap(decodeString(Ok, Err), Ok, Err)(undefined);

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  undefined

as a Map, but could not.
`.trim(),
  );
});

test("OK decoder", () => {
  const decoded = decoder(
    "Test",
    {
      key: [decodeString(Ok, Err), "x"],
    },
    Ok,
    Err,
  )({ x: "value" });

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toStrictEqual({ key: "value", [Name]: "Test" });
});

test("FAIL decoder", () => {
  const decoded = decoder(
    "Test",
    {
      key: [decodeString(Ok, Err), "x"],
    },
    Ok,
    Err,
  )({ x: 0 });

  expect(decoded).toBeInstanceOf(Err);
  expect(decoded._0.toString()).toBe(
    `
I was trying to decode the value:

  0

as a String, but could not.

The input is in this object:

  {
    "x": 0
  }

at: x
`.trim(),
  );
});

test("OK decodeObject", () => {
  const decoded = decodeObject(Ok)({});

  expect(decoded).toBeInstanceOf(Ok);
  expect(decoded._0).toStrictEqual({});
});
