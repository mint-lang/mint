import { signal } from "@preact/signals";

// We have global signals for translations.
export const translations = signal({});
export const locale = signal({});

// Global functions to set the locale and translate a key
// with the current locale.
export const setLocale = (value) => (locale.value = value);
export const translate = (key) =>
  (translations.value[locale.value] || {})[key] || "";
