import { expect, test, describe } from "vitest";
import { normalizeEvent } from "../index";

describe("normalizeEvent", () => {
  test("returns default values if they are not defined", () => {
    const event = normalizeEvent({ test: "X", preventDefault: () => "P" });

    expect(event.dataTransfer).not.toBe(undefined);

    expect(event.dataTransfer.setData("test", "test")).toBe(null);
    expect(event.dataTransfer.getData("not present")).toBe("");
    expect(event.dataTransfer.getData("test")).toBe("test");
    expect(event.dataTransfer.clearData()).toBe(null);

    expect(event.clipboardData).not.toBe(undefined);
    expect(event.preventDefault()).toBe("P");
    expect(event.data).toBe("");
    expect(event.altKey).toBe(false);
    expect(event.charCode).toBe(-1);
    expect(event.ctrlKey).toBe(false);
    expect(event.key).toBe("");
    expect(event.keyCode).toBe(-1);
    expect(event.locale).toBe("");
    expect(event.location).toBe(-1);
    expect(event.metaKey).toBe(false);
    expect(event.repeat).toBe(false);
    expect(event.shiftKey).toBe(false);
    expect(event.which).toBe(-1);
    expect(event.button).toBe(-1);
    expect(event.buttons).toBe(-1);
    expect(event.clientX).toBe(-1);
    expect(event.clientY).toBe(-1);
    expect(event.pageX).toBe(-1);
    expect(event.pageY).toBe(-1);
    expect(event.screenY).toBe(-1);
    expect(event.screenX).toBe(-1);
    expect(event.detail).toBe(-1);
    expect(event.deltaMode).toBe(-1);
    expect(event.deltaX).toBe(-1);
    expect(event.deltaY).toBe(-1);
    expect(event.deltaZ).toBe(-1);
    expect(event.animationName).toBe("");
    expect(event.pseudoElement).toBe("");
    expect(event.elapsedTime).toBe(-1);
    expect(event.propertyName).toBe("");
    expect(event.blah).toBe(undefined);
    expect(event.test).toBe("X");
  });
});
