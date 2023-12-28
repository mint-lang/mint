require "baked_file_system"
require "ansi-escapes"
require "file_utils"
require "colorize"
require "markd"
require "kemal"
require "uuid"
require "html"
require "json"
require "ecr"
require "xml"

MINT_ENV = {} of String => String

require "./version"

require "./ext/**"
require "./errorable"

require "./constants"
require "./assets"
require "./skippable"
require "./helpers"
require "./js"
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
require "./formatter"

require "./compilers2/**"
require "./compiler2/**"
require "./compiler2"

require "./compilers/**"
require "./compiler"

require "./installer/**"
require "./installer"

require "./parsers/**"
require "./parser/*"
require "./parser"

require "./documentation_generator/**"
require "./documentation_generator"
require "./documentation_server"

require "./semantic_tokenizer"

require "./test_runner/**"
require "./test_runner"

require "./lsp/**"
require "./ls/**"

require "./mint_json"
require "./app_init/scaffold"
require "./reactor"
require "./builder"
require "./sandbox_server"
require "./cli"
require "./workspace"
require "./debugger"
require "./artifact_cleaner"
