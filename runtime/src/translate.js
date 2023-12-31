import { signal } from "@preact/signals";

export const translations = signal({});
export const locale = signal({});

export const setLocale = (value) => (locale.value = value);
export const translate = (key) =>
  (translations.value[locale.value] || {})[key] || "";
