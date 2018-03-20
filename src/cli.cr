require "admiral"
require "./commands/command"
require "./commands/**"

class CliException < Exception
end

class Cli < Admiral::Command
  define_help description: "Mint"

  register_sub_command install : Install
  register_sub_command build : Build
  register_sub_command start : Start
  register_sub_command init : Init
  register_sub_command test : Test
  register_sub_command loc : Loc

  def run
    puts help
  end
end
