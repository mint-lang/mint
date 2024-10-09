module Mint
  class Cli < Admiral::Command
    class Tool < Admiral::Command
      include Command

      define_help description: "Miscellaneous Tools"

      register_sub_command "ls-websocket", type: LsWebSocket
      register_sub_command highlight, type: Highlight
      register_sub_command clean, type: Clean
      register_sub_command loc, type: Loc
      register_sub_command ls, type: Ls

      def run
        execute "Help" do
          terminal.puts help
        end
      end
    end
  end
end
