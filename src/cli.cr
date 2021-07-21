require "admiral"
require "./commands/command"
require "./commands/**"

module Mint
  command_error EnvFileNotFound
  command_error RuntimeFileNotFound

  class CliException < Exception
  end

  class Cli < Admiral::Command
    include Command

    define_help description: "Mint"

    register_sub_command "sandbox-server", type: SandboxServer
    register_sub_command install, type: Install
    register_sub_command compile, type: Compile
    register_sub_command version, type: Version
    register_sub_command format, type: Format
    register_sub_command build, type: Build
    register_sub_command start, type: Start
    register_sub_command clean, type: Clean
    register_sub_command init, type: Init
    register_sub_command lint, type: Lint
    register_sub_command test, type: Test
    register_sub_command docs, type: Docs
    register_sub_command loc, type: Loc
    register_sub_command ls, type: Ls

    def run
      execute "Help" do
        terminal.puts help
      end
    end
  end
end
