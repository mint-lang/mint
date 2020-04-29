require "string_inflection"
require "baked_file_system"
require "tree_template"
require "time_format"
require "file_utils"
require "colorize"
require "markd"
require "kemal"
require "uuid"
require "html"
require "json"

MINT_ENV = {} of String => String

require "./version"

require "./ext/**"

require "./errors/error"
require "./errors/**"
require "./constants"
require "./macros"
require "./assets"
require "./js"
require "./core"
require "./env"

require "./render/**"
require "./utils/**"

require "./message"
require "./messages/**"

require "./ast/node"
require "./ast/**"
require "./ast"

require "./style_builder"

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

require "./documentation_generator/**"
require "./documentation_generator"
require "./documentation_server"

require "./test_runner/**"
require "./test_runner"

require "./mint_json"
require "./scaffold"
require "./reactor"
require "./builder"
require "./cli"
require "./debugger"
