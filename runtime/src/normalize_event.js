import { options } from "preact";

// Polyfill DataTransfer
if (!("DataTransfer" in window)) {
  window.DataTransfer = class {
    constructor() {
      this.effectAllowed = "none";
      this.dropEffect = "none";
      this.files = [];
      this.types = [];
      this.cache = {};
    }

    getData(format) {
      return this.cache[format] || "";
    }

    setData(format, data) {
      this.cache[format] = data;
      return null;
    }

    clearData() {
      this.cache = {};
      return null;
    }
  };
}

// Set the event option hook to normalize the event so we can use one type
// for events (`Html.Event``) instead of multiple event types like in
// JavaScript (`MouseEvent`, `KeyboardEvent`, etc...). Basically we make sure
// that there are values for all fields using a proxy (which makes it lazy).
export const normalizeEvent = (event) => {
  return new Proxy(event, {
    get: function (obj, prop) {
      if (prop === "event") {
        return event;
      } else if (prop in obj) {
        const value = obj[prop];

        if (value instanceof Function) {
          return () => obj[prop]();
        } else {
          return value;
        }
      } else {
        switch (prop) {
          // onCopy onCut onPaste
          case "clipboardData":
            return (obj.clipboardData = new DataTransfer());

          // drag events
          case "dataTransfer":
            return (obj.dataTransfer = new DataTransfer());

          // onCompositionEnd onCompositionStart onCompositionUpdate
          case "data":
            return "";

          // onKeyDown onKeyPress onKeyUp
          case "altKey":
            return false;
          case "charCode":
            return 0;
          case "ctrlKey":
            return false;
          case "key":
            return "";
          case "keyCode":
            return 0;
          case "locale":
            return "";
          case "location":
            return 0;
          case "metaKey":
            return false;
          case "repeat":
            return false;
          case "shiftKey":
            return false;
          case "which":
            return 0;

          // onClick onContextMenu onDoubleClick onDrag onDragStart onDragEnd
          // onDragEnter onDragExit onDragLeave onDragOver onDrop onMouseDown
          // onMouseEnter onMouseLeave onMouseMove onMouseOut onMouseOver
          // onMouseUp
          case "button":
            return -1; // 0 is the left button
          case "buttons":
            return 0;
          case "clientX":
            return 0;
          case "clientY":
            return 0;
          case "pageX":
            return 0;
          case "pageY":
            return 0;
          case "screenX":
            return 0;
          case "screenY":
            return 0;
          case "layerX":
            return 0;
          case "layerY":
            return 0;
          case "offsetX":
            return 0;
          case "offsetY":
            return 0;

          // onScroll
          case "detail":
            return 0;

          // onWheel
          case "deltaMode":
            return -1; // 0 is pixels
          case "deltaX":
            return 0;
          case "deltaY":
            return 0;
          case "deltaZ":
            return 0;

          // onAnimationStart onAnimationEnd onAnimationIteration
          case "animationName":
            return "";
          case "pseudoElement":
            return "";
          case "elapsedTime":
            return 0;

          // onTransitionEnd
          case "propertyName":
            return "";

          default:
            return undefined;
        }
      }
    },
  });
};

// Set the event preact hook.
options.event = normalizeEvent;
