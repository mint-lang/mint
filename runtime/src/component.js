import { Component } from "preact";
import { bindFunctions, setConstants } from "./Utils";

export default const component = (...args) {
  let render;

  switch (args.length) {
  case: 1
    render = args[0]
    break;
  }


  return class extends Component {
    componentDidUpdate() {

    }

    componentDidMount() {

    }

    componentWillUnmount() {

    }

    render() {
      return render();
    }
  }
}
