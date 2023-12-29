import { untracked } from "@preact/signals";
import { useEffect } from "preact/hooks";

// This creates a function which is used for subscribing to a provider.
export const createProvider = (subscriptions, update) => {
  // This is the subscription function.
  return (subscription) => {
    untracked(() => {
      subscriptions.value = [...subscriptions.value, subscription];
      update();
    });

    // Cleanup function.
    return () => {
      untracked(() => {
        subscriptions.value = subscriptions.value.filter(
          (item) => item != subscription,
        );
        update();
      });
    };
  };
};

// A hook for using providers. On mount and every change we subscribe to the
// given providers (if the condition is missing or true). The cleanup runs
// before the resubscription so there won't be any invalid subscriptions.
export const useProviders = (providers) => {
  useEffect(() => {
    const cleanups = providers.map((provider) => {
      if (provider.length === 1 || provider[1]) {
        return provider[0]();
      }
    });

    return () => {
      cleanups.forEach((item) => {
        if (item) {
          item();
        }
      });
    };
  });
};
