require "baked_file_system"
require "ansi-escapes"
require "compress/zip"
require "file_utils"
require "colorize"
require "markd"
require "uuid"
require "http"
require "html"
require "json"
require "xml"

MINT_ENV = {} of String => String

require "./version"

require "./ext/**"

require "./error_message"
require "./message"
require "./errorable"
require "./error"
require "./warning"
require "./warnable"

require "./exhaustiveness_checker"
require "./constants"
require "./helpers"
require "./logger"
require "./assets"
require "./core"
require "./env"

require "./render/**"
require "./utils/**"

require "./ast/node"
require "./ast/**"
require "./ast"

require "./style_builder"
require "./scope"

require "./type_checkers/**"
require "./type_checker/**"
require "./type_checker"

require "./formatters/**"
require "./formatter/**"
require "./formatter"

require "./compilers/**"
require "./compiler/**"
require "./compiler"

require "./installer/**"
require "./installer"

require "./parsers/**"
require "./parser/*"
require "./parser"

require "./documentation_generator"
require "./static_documentation_generator"

require "./semantic_tokenizer"
require "./references_tracker"

require "./test_runner/**"
require "./test_runner"

require "./lsp/**"
require "./ls/**"

require "./mint_json/**"
require "./mint_json"

require "./workspace"
require "./scaffold"
require "./debugger"
require "./reactor"
require "./bundler"
require "./cli"
