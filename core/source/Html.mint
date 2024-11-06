/* This module provides functions for working with `Html`. */
module Html {
  /*
  Returns an empty `Html` object. It is useful for example if you don't want to
  render something conditionally. Same as an empty fragment `<></>`.

    if (Array.isEmpty(items)) {
      Html.empty()
    } else {
      <div>
        items
      </div>
    }
  */
  fun empty : Html {
    <></>
  }

  /*
  Returns whether or not the html is empty.

    Html.isEmpty(<div></div>) == false
    Html.isEmpty(<></>) == true
  */
  fun isEmpty (html : Html) : Bool {
    `!#{html}`
  }

  /*
  Returns whether or not the html is not empty.

    Html.isNotEmpty(<div></div>) == true
    Html.isNotEmpty(<></>) == false
  */
  fun isNotEmpty (html : Html) : Bool {
    `!!#{html}`
  }
}
