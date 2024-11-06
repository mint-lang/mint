import { deepEqual } from "fast-equals";
import RouteParser from "route-parser";
import { h, render } from "preact";

// An internally used error when we can't decode route parameters.
class DecodingError extends Error {}

// Comparison function for route variables later on.
const equals = (a, b) => {
  if (a instanceof Object) {
    return b instanceof Object && deepEqual(a, b);
  } else {
    return !(b instanceof Object) && a === b;
  }
};

// `queueMicrotask` polyfill.
const queueTask = (callback) => {
  if (typeof window.queueMicrotask !== "function") {
    Promise.resolve()
      .then(callback)
      .catch((e) =>
        setTimeout(() => {
          throw e;
        }),
      );
  } else {
    window.queueMicrotask(callback);
  }
};

// Returns the route information by parsing the route.
const getRouteInfo = (url, routes) => {
  for (let route of routes) {
    if (route.path === "*") {
      return { route: route, vars: false, url: url };
    } else {
      let vars = new RouteParser(route.path).match(url);

      if (vars) {
        return { route: route, vars: vars, url: url };
      }
    }
  }

  return null;
};

class Program {
  constructor(ok, routes) {
    this.root = document.createElement("div");
    this.routeInfo = null;
    this.routes = routes;
    this.ok = ok;

    document.body.appendChild(this.root);

    window.addEventListener("popstate", this.handlePopState.bind(this));
    window.addEventListener("click", this.handleClick.bind(this), true);
  }

  handleClick(event) {
    // If someone prevented default we honor that.
    if (event.defaultPrevented) {
      return;
    }

    // If the control is pressed it means that the user wants
    // to open it a new tab so we honor that.
    if (event.ctrlKey) {
      return;
    }

    for (let element of event.composedPath()) {
      if (element.tagName === "A") {
        // If the target is not empty then it's probably `_blank` or
        // an other window or frame so we skip.
        if (element.target.trim() !== "") {
          return;
        }

        // We only handle same origin URLs.
        if (element.origin === window.location.origin) {
          const fullPath = element.pathname + element.search + element.hash;
          const routeInfo = getRouteInfo(fullPath, this.routes);

          // If we found a matchin route, we prevent default and navigate to
          // that route.
          if (routeInfo) {
            event.preventDefault();

            navigate(
              fullPath,
              /* dispatch */ true,
              /* triggerJump */ true,
              routeInfo,
            );
            return;
          }
        }
      }
    }
  }

  // Handles resolving the page position after a navigation event.
  resolvePagePosition(triggerJump) {
    // Queue a microTask, this will run after Preact does a render.
    queueTask(() => {
      // On the next frame, the DOM should be updated already.
      requestAnimationFrame(() => {
        const hash = window.location.hash;

        if (hash) {
          let elem = null;

          try {
            elem =
              this.root.querySelector(hash) || // ID
              this.root.querySelector(`a[name="${hash.slice(1)}"]`); // Anchor
          } catch {}

          if (elem) {
            if (triggerJump) {
              elem.scrollIntoView();
            }
          } else {
            console.warn(
              `MINT: ${hash} matches no element with an id and no link with a name`,
            );
          }
        } else if (triggerJump) {
          window.scrollTo(0, 0);
        }
      });
    });
  }

  // Handles navigation events.
  async handlePopState(event) {
    const url =
      window.location.pathname + window.location.search + window.location.hash;

    const routeInfo = event?.routeInfo || getRouteInfo(url, this.routes);

    if (routeInfo) {
      if (
        this.routeInfo === null ||
        routeInfo.url !== this.routeInfo.url ||
        !equals(routeInfo.vars, this.routeInfo.vars)
      ) {
        const handler = this.runRouteHandler(routeInfo);
        if (routeInfo.route.await) { await handler }
      }

      this.resolvePagePosition(!!event?.triggerJump);
    }

    this.routeInfo = routeInfo;
  }

  // Helper function for above.
  async runRouteHandler(routeInfo) {
    const { route } = routeInfo;

    if (route.path === "*") {
      return route.handler();
    } else {
      const { vars } = routeInfo;

      try {
        let args = route.mapping.map((name, index) => {
          const value = vars[name];
          const result = route.decoders[index](value);

          if (result instanceof this.ok) {
            return result._0;
          } else {
            throw new DecodingError();
          }
        });

        return route.handler.apply(null, args);
      } catch (error) {
        if (error.constructor !== DecodingError) {
          throw error;
        }
      }
    }
  }

  // Renders the program and runs current route handlers.
  render(main, globals) {
    const components = [];

    for (let key in globals) {
      components.push(h(globals[key], { key: key }));
    }

    let mainNode;
    if (typeof main !== "undefined") {
      mainNode = h(main, { key: "MINT_MAIN" })
    }

    render([...components, mainNode], this.root);
    this.handlePopState();
  }
}

// Function to navigate to a different url.
export const navigate = (
  url,
  dispatch = true,
  triggerJump = true,
  routeInfo = null,
) => {
  let pathname = window.location.pathname;
  let search = window.location.search;
  let hash = window.location.hash;

  let fullPath = pathname + search + hash;

  if (fullPath !== url) {
    if (dispatch) {
      window.history.pushState({}, "", url);
    } else {
      window.history.replaceState({}, "", url);
    }
  }

  if (dispatch) {
    let event = new PopStateEvent("popstate");
    event.triggerJump = triggerJump;
    event.routeInfo = routeInfo;
    dispatchEvent(event);
  }
};

// Creates a program.
export const program = (main, globals, ok, routes = []) => {
  new Program(ok, routes).render(main, globals);
};
