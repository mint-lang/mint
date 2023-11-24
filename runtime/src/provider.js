import { useEffect, useMemo } from "preact/hooks";
import { untracked } from "@preact/signals";
import { compare } from "./equality";
import uuid from "uuid-random";

// This creates a function which is used for subscribing to a provider. We use
// `untracked` to not to subscribe to any outside signals.
export const createProvider = (subscriptions, update) => {
  // This is the subscription function.
  return (owner, object) => {
    const unsubscribe = () => {
      if (subscriptions.has(owner)) {
        subscriptions.delete(owner);
        untracked(update);
      }
    };

    // This will only run when the component unmounts.
    useEffect(() => {
      return unsubscribe;
    }, []);

    // This runs on every update so we don't return a cleanup function.
    useEffect(() => {
      const data = object();

      // If the object is null that means we need to unsubscribe.
      if (data === null) {
        unsubscribe();
      } else {
        const current = subscriptions.get(owner);

        if (!compare(current, data)) {
          subscriptions.set(owner, data);
          untracked(update);
        }
      }
    });
  };
};

// Returns the subscriptions as an array.
export const subscriptions = (items) => Array.from(items.values());

// Returns a unique ID for a component which doesn't change.
export const useId = () => useMemo(uuid, []);
export { uuid };
