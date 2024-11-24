import { compare } from "./equality";
import { render, h } from "preact";

// This is a class for tests. It allows to have multiple steps which are
// evaluated asynchronously.
class TestContext {
  constructor(subject, teardown) {
    this.teardown = teardown;
    this.subject = subject;
    this.steps = [];
  }

  async run() {
    let result;

    try {
      result = await new Promise(this.next.bind(this));
    } finally {
      this.teardown && this.teardown();
    }

    return result;
  }

  async next(resolve, reject) {
    requestAnimationFrame(async () => {
      let step = this.steps.shift();

      if (step) {
        try {
          this.subject = await step(this.subject);
        } catch (error) {
          return reject(error);
        }
      }

      if (this.steps.length) {
        this.next(resolve, reject);
      } else {
        resolve(this.subject);
      }
    });
  }

  step(proc) {
    this.steps.push(proc);
    return this;
  }
}

// This is the test runner which runs the tests and sends reports to
// the CLI using websockets.
class TestRunner {
  constructor(suites, globals, url, id) {
    this.root = document.createElement("div")
    document.body.appendChild(this.root);

    this.socket = new WebSocket(url);
    this.globals = globals;
    this.suites = suites;
    this.url = url;
    this.id = id;

    // Catch debug messages.
    window.DEBUG = {
      log: (value) => {
        let result = "";

        if (value === undefined) {
          result = "undefined";
        } else if (value === null) {
          result = "null";
        } else {
          result = value.toString();
        }

        this.log(result);
      },
    };

    let error = null;

    window.onerror = (message) => {
      if (this.socket.readyState === 1) {
        this.crash(message);
      } else {
        error = error || message;
      }
    };

    this.socket.onopen = () => {
      if (error != null) {
        this.crash(error);
      }
    };

    this.start();
  }

  renderGlobals() {
    const components = [];

    for (let key in this.globals) {
      components.push(h(this.globals[key], { key: key }));
    }

    render(components, this.root);
  }

  start() {
    if (this.socket.readyState === 1) {
      this.run();
    } else {
      this.socket.addEventListener("open", () => this.run());
    }
  }

  run() {
    return new Promise((resolve, reject) => {
      this.next(resolve, reject);
    })
      .catch((e) => this.log(e.reason))
      .finally(() => this.socket.send("DONE"));
  }

  report(type, suite, name, message, location) {
    if (message && message.toString) {
      message = message.toString();
    }

    this.socket.send(
      JSON.stringify({
        location: location,
        result: message,
        suite: suite,
        id: this.id,
        type: type,
        name: name,
      }),
    );
  }

  reportTested(test, type, message) {
    this.report(type, this.suite.name, test.name, message, test.location);
  }

  crash(message) {
    this.report("CRASHED", null, null, message);
  }

  log(message) {
    this.report("LOG", null, null, message);
  }

  cleanSlate() {
    return new Promise((resolve) => {
      // Cleanup globals.
      render(null, this.root);

      // Set the URL to the root one.
      if (window.location.pathname !== "/") {
        window.history.replaceState({}, "", "/");
      }

      // Clear storages.
      sessionStorage.clear();
      localStorage.clear();

      // TODO: Reset Stores

      // Wait for rendering.
      requestAnimationFrame(() => {
        this.renderGlobals();
        requestAnimationFrame(resolve);
      })
    })
  }

  next(resolve) {
    requestAnimationFrame(async () => {
      if (!this.suite || this.suite.tests.length === 0) {
        this.suite = this.suites.shift();

        if (this.suite) {
          this.report("SUITE", this.suite.name);
        } else {
          return resolve();
        }
      }

      const test = this.suite.tests.shift();

      try {
        await this.cleanSlate();

        const result = await test.proc();

        if (result instanceof TestContext) {
          try {
            await result.run();
            this.reportTested(test, "SUCCEEDED", result.subject);
          } catch (error) {
            this.reportTested(test, "FAILED", error);
          }
        } else {
          if (result) {
            this.reportTested(test, "SUCCEEDED");
          } else {
            this.reportTested(test, "FAILED");
          }
        }
      } catch (error) {
        console.log(error)
        // An error occurred while trying to run a test; this is different from the test itself failing.
        this.reportTested(test, "ERRORED", error);
      }

      this.next(resolve);
    });
  }
}

// This function creates a test for an equality operation (either == or !=).
export const testOperation = (left, right, operator) => {
  return new TestContext(left).step((subject) => {
    let result = compare(subject, right);

    if (operator === "==") {
      result = !result;
    }

    if (result) {
      throw `Assertion failed: ${right} ${operator} ${subject}`;
    }

    return true;
  });
};

export const testContext = TestContext;
export const testRunner = TestRunner;
