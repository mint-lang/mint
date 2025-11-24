export { createElement, Fragment as fragment, createContext } from "preact";
export { useEffect, useMemo, useContext } from "preact/hooks";
export { signal, batch } from "@preact/signals";

export const promiseAll = (value) => Promise.all(value);

export * from "./src/pattern_matching";
export * from "./src/normalize_event";
export * from "./src/utilities";
export * from "./src/translate";
export * from "./src/equality";
export * from "./src/provider";
export * from "./src/decoders";
export * from "./src/encoders";
export * from "./src/program";
export * from "./src/portals";
export * from "./src/variant";
export * from "./src/styles";
export * from "./src/debug";

