require "string_inflection"
require "baked_file_system"
require "duktape/runtime"
require "tree_template"
require "time_format"
require "file_utils"
require "colorize"
require "kemal"
require "html"

require "./ext/**"

require "./errors/**"
require "./constants"
require "./macros"
require "./assets"

require "./utils/**"

require "./message"
require "./messages/**"

require "./type_checkers/**"
require "./type_checker"

require "./formatters/**"
require "./formatter"

require "./compilers/**"
require "./compiler"

require "./installer/**"
require "./installer"

require "./parsers/**"
require "./parser"

require "./test_runner/**"
require "./test_runner"

require "./ast/node"
require "./ast/**"
require "./ast"

require "./mint_json"
require "./scaffold"
require "./reactor"
require "./builder"
require "./render"
require "./cli"
