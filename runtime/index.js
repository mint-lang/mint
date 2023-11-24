export { signal, computed, useSignal, useComputed, batch, effect } from '@preact/signals';
export { useEffect }from 'preact/hooks';
export { createElement } from 'preact';

import { Fragment } from 'preact';

export const fragment = Fragment;

export * from './src/pattern_matching';
export * from './src/normalize_event';
export * from './src/utilities';
export * from './src/equality';
export * from './src/provider';
export * from './src/decoders';
export * from './src/encoders';
export * from './src/program';
export * from './src/variant';
export * from './src/styles';

export const toArray = function () {
  let items = Array.from(arguments);
  if (Array.isArray(items[0]) && items.length === 1) {
    return items[0];
  } else {
    return items;
  }
};
