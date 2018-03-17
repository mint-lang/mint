require "colorize"
require "string_inflection"
require "html"

require "./errors/**"
require "./ext/**"

require "./messages"
require "./assets"
require "./logger"
require "./utils/**"
require "./type_checker"
require "./formatter"
require "./compiler"
require "./installer"
require "./builder"
require "./parser"
require "./ast"
require "./cli"

require "./nodes/**"

Cli.run
