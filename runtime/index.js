export { createElement, Fragment as fragment } from "preact";
export { createPortal } from "preact/compat";
export { useEffect } from "preact/hooks";

export {
  useComputed,
  useSignal,
  computed,
  signal,
  effect,
  batch,
} from "@preact/signals";

export * from "./src/pattern_matching";
export * from "./src/normalize_event";
export * from "./src/utilities";
export * from "./src/equality";
export * from "./src/provider";
export * from "./src/decoders";
export * from "./src/encoders";
export * from "./src/program";
export * from "./src/variant";
export * from "./src/styles";
