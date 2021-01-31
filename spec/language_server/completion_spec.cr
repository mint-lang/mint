require "../spec_helper"

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
      lsp(
        id: 0,
        method: "textDocument/completion",
        message: {
          textDocument: {uri: workspace.file_path("test.mint")},
          position:     {line: 2, character: 4},
        })
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
      lsp(
        id: 0,
        method: "textDocument/completion",
        message: {
          textDocument: {uri: workspace.file_path("test.mint")},
          position:     {line: 2, character: 4},
        })
    end
  end
end
