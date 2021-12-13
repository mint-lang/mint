require "../spec_helper"

struct LSPResult
  include JSON::Serializable

  property result : Array(LSP::CompletionItem)
end

describe "Language Server Completion" do
  it "returns snippets for html components while in a Html function" do
    with_workspace do |workspace|
      workspace.file "test.mint", <<-MINT
      component Test {
        fun render : Html {
          <></>
        }
      }
      MINT

      # TODO: Assert
      lsp([{
        id:      0,
        method:  "textDocument/completion",
        message: {
          textDocument: {uri: workspace.file_path("test.mint")},
          position:     {line: 2, character: 4},
        },
      }])
    end
  end

  it "returns completions while in a function" do
    with_workspace do |workspace|
      workspace.file "test.mint", <<-MINT
      component Test {
        fun otherFunction (name : String) : String {
          name
        }

        fun render : String {
          "Hello"
        }
      }
      MINT

      # TODO: Assert
      result =
        lsp([
          {
            id:      0,
            method:  "initialize",
            message: {
              capabilities: {
                textDocument: {
                  completion: {
                    completionItem: {
                      snippetSupport: false,
                    },
                  },
                },
              },
            },
          },
          {
            id:      1,
            method:  "textDocument/completion",
            message: {
              textDocument: {uri: workspace.file_path("test.mint")},
              position:     {line: 2, character: 4},
            },
          },
        ])

      case item = result[1]
      when String
        completion =
          LSPResult
            .from_json(item)
            .result
            .find { |message| message.label == "Test" }

        if completion
          completion.insert_text.should_not contain("$0")
        else
          fail "No completion!"
        end
      else
        fail "Should have succeeded."
      end
    end
  end
end
