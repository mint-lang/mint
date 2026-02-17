module Mint
  module LS
    class CompletionRequest < LSP::RequestMessage
      property params : LSP::CompletionParams

      def execute(server)
        snippet_support =
          server
            .params
            .try(&.capabilities.text_document)
            .try(&.completion)
            .try(&.completion_item)
            .try(&.snippet_support) || false

        workspace =
          server.workspace(params.path)

        type_checker =
          case item = workspace.result.value
          in TypeChecker
            item
          in Error
          end

        Completion.new(
          snippet_support: snippet_support,
          type_checker: type_checker,
          workspace: workspace
        ).process(params)
      end
    end
  end
end
