export { createElement, Fragment as fragment } from "preact";
export { useEffect, useMemo, useRef } from "preact/hooks";
export { createPortal } from "preact/compat";

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
export * from "./src/translate";
export * from "./src/equality";
export * from "./src/provider";
export * from "./src/decoders";
export * from "./src/encoders";
export * from "./src/program";
export * from "./src/variant";
export * from "./src/styles";
