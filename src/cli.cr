require "admiral"
require "./command"
require "./commands/**"

module Mint
  class Cli < Admiral::Command
    include Command

    define_help description: "Mint Programming Language"

    register_sub_command install, type: Install
    register_sub_command version, type: Version
    register_sub_command format, type: Format
    register_sub_command build, type: Build
    register_sub_command start, type: Start
    register_sub_command tool, type: Tool
    register_sub_command init, type: Init
    register_sub_command lint, type: Lint
    register_sub_command test, type: Test
    register_sub_command docs, type: Docs

    def run
      execute "Help" do
        terminal.puts help
      end
    end
  end
end
