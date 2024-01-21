import { render, fireEvent } from "@testing-library/preact";
import { expect, test, describe } from "vitest";
import { useState } from "preact/hooks";
import { h } from "preact";

import { createProvider, useProviders, useId, subscriptions } from "../index";

const map = new Map();
const provider = createProvider(map, () => {});

describe("providers", () => {
  test("works correctly", () => {
    /*
    const item = h(() => {
      const [count, setCount] = useState(0);
      const id = useId();

      useProviders([() => provider(id, count == 1 ? {} : null)]);

      return h("div", { onClick: () => setCount(1) }, "TEST");
    });

    const items = subscriptions(map);
    const container = render(item);

    fireEvent.click(container.getByText("TEST"));
    */
  });
});
