// Parses style data for an HTML element which can come in multiple forms:
//
//  style="color: red" - A CSS string (we need to parse this)
//  style={Map.set(Map.empty(), "color", "red")} - A Mint `Map`
//  style=[{"color", "red"}] - A Mint Array of tuples
//  style={`{color: "red"}`} - A JavaScript object
export const style = (items) => {
  const result = {};

  const setKeyValue = (key, value) => {
    result[key.toString().trim()] = value.toString().trim();
  };

  for (let item of items) {
    if (typeof item === "string") {
      item.split(";").forEach((prop) => {
        const [key, value] = prop.split(":");

        if (key && value) {
          setKeyValue(key, value);
        }
      });
    } else if (item instanceof Map || item instanceof Array) {
      for (let [key, value] of item) {
        setKeyValue(key, value);
      }
    } else {
      for (let key in item) {
        setKeyValue(key, item[key]);
      }
    }
  }

  return result;
};
