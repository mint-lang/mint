module Mint
  module LS
    # This is a Mint only LSP request to compile the workspace as a sandbox.
    class SandboxCompile < LSP::RequestMessage
      def execute(server : Server)
        workspace =
          server.workspace("")

        result =
          workspace.update_cache

        bundle =
          case result
          in Ast
            Bundler.new(
              artifacts: workspace.type_checker.artifacts,
              json: workspace.json,
              config: Bundler::Config.new(
                generate_manifest: false,
                include_program: true,
                hash_assets: false,
                runtime_path: nil,
                live_reload: false,
                skip_icons: false,
                relative: false,
                optimize: true,
                test: nil),
            ).bundle
          in Error
            {"index.html" => ->{ result.to_html }}
          end

        io =
          IO::Memory.new

        Compress::Zip::Writer.open(io) do |zip|
          bundle.each do |path, contents|
            zip.add(path, contents.call)
          end
        end

        io.rewind
        HTTP::Client.post("https://#{@id}.sandbox.mint-lang.com/", body: io)
        {url: "https://#{@id}.sandbox.mint-lang.com/"}
      end
    end
  end
end
