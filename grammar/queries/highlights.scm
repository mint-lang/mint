; Syntax highlighting for the Mint language.
; Capture names follow the tree-sitter highlighting conventions:
; https://tree-sitter.github.io/tree-sitter/syntax-highlighting#highlights

; -----------------------------------------------------------------------------
; Comments
; -----------------------------------------------------------------------------

(comment) @comment

; -----------------------------------------------------------------------------
; Keywords
; -----------------------------------------------------------------------------

[
  "module"
  "component"
  "provider"
  "store"
  "suite"
  "routes"
  "locale"
  "type"
] @keyword

[
  "fun"
  "const"
  "property"
  "state"
  "get"
  "context"
  "signal"
  "style"
  "connect"
  "provide"
  "use"
  "test"
] @keyword

[
  "global"
  "async"
] @keyword.modifier

[
  "if"
  "else"
  "case"
  "for"
  "of"
  "when"
] @keyword.control.conditional

[
  "await"
  "defer"
  "next"
  "return"
  "decode"
  "encode"
  "emit"
  "dbg"
] @keyword.control

[
  "exposing"
  "as"
  "using"
  "context"
  "or"
] @keyword

; -----------------------------------------------------------------------------
; Literals
; -----------------------------------------------------------------------------

(number_literal) @number
(bool_literal) @constant.builtin.boolean

(string) @string
(string_content) @string
(escape_sequence) @string.escape
(regexp_literal) @string.regex

(js) @embedded
(js_content) @embedded
(here_document) @string
(here_document_content) @string

[
  "#{"
  "}"
] @punctuation.special
(interpolation) @none

; -----------------------------------------------------------------------------
; Types
; -----------------------------------------------------------------------------

(type name: (id) @type)
(type_definition name: (id) @type)
(type_variant name: (id) @type)
(type_parameters (variable) @type.parameter)
(provider subscription: (id) @type)

; A bare lowercase identifier in a type position is a type variable.
(type_annotation (variable) @type.parameter)
(type_definition_field type: (variable) @type.parameter)

; -----------------------------------------------------------------------------
; Definitions
; -----------------------------------------------------------------------------

(module_definition name: (id) @namespace)
(component name: (id) @type)
(store name: (id) @namespace)
(provider name: (id) @namespace)

(function name: (variable) @function)
(get name: (variable) @function)
(signal name: (variable) @function)
(style name: (variable) @function)

(constant name: (variable) @constant)

(property name: (variable) @variable.member)
(state name: (variable) @variable.member)
(context name: (variable) @variable.member)

(argument name: (variable) @variable.parameter)

; -----------------------------------------------------------------------------
; Expressions
; -----------------------------------------------------------------------------

(call
  expression: (variable) @function.call)
(call
  expression: (access field: (variable) @function.method.call))

(access field: (variable) @variable.member)
(record_field key: (variable) @property)
(type_definition_field key: (variable) @property)

(builtin) @function.builtin
(env (variable) @constant.builtin)

; A capitalized bare identifier is a module / type / constant reference.
((variable) @type
  (#match? @type "^[A-Z]"))

(variable) @variable

; -----------------------------------------------------------------------------
; Directives
; -----------------------------------------------------------------------------

(path_directive name: _ @function.macro)
(block_directive name: _ @function.macro)
"@size" @function.macro
(env "@" @function.macro)
(path_directive path: (path) @string.special.path)

; -----------------------------------------------------------------------------
; HTML
; -----------------------------------------------------------------------------

(html_tag) @tag
(html_component component: (id) @tag)
(html_component_closing_tag (id) @tag)
(html_attribute_name) @tag.attribute

[
  "/>"
  "</"
  "</>"
] @tag.delimiter

; -----------------------------------------------------------------------------
; CSS
; -----------------------------------------------------------------------------

(css_property) @property
(css_selector_name) @tag
(css_keyframes_name) @label
(css_condition) @string
(css_value_content) @string
"@keyframes" @keyword
"@font-face" @keyword
(css_nested_at) @keyword

; -----------------------------------------------------------------------------
; Operators & punctuation
; -----------------------------------------------------------------------------

[
  "+" "-" "*" "/" "%" "**"
  "==" "!=" "<" ">" "<=" ">="
  "&&" "||"
  "|>"
  "="
  "|"
  "=>"
] @operator

(negation) @operator

[
  "(" ")"
  "{" "}"
  "[" "]"
] @punctuation.bracket

[
  ","
  "."
  ":"
  "::"
] @punctuation.delimiter

(discard) @comment
