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

        case type_checker = workspace.result
        in TypeChecker
          Completion.new(
            snippet_support: snippet_support,
            type_checker: type_checker,
            workspace: workspace
          ).process(params)
        in Error
        end
      end
    end
  end
end
