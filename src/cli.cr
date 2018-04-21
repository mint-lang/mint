require "admiral"
require "./commands/command"
require "./commands/**"

class CliException < Exception
end

class Cli < Admiral::Command
  define_help description: "Mint"

  register_sub_command install, type: Install
  register_sub_command build, type: Build
  register_sub_command start, type: Start
  register_sub_command init, type: Init
  register_sub_command test, type: Test
  register_sub_command loc, type: Loc

  def run
    puts help
  end
end
