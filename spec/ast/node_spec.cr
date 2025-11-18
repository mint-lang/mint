require "../spec_helper"

describe Mint::Ast::Node do
  context "#contains?" do
    it "checks if the location is contained within the node" do
      example =
        <<-MINT
        component Test {
          fun render : Html {
            <div></div>
          }
        }
        MINT

      node =
        Mint::Parser
          .parse(example, "example.mint")
          .components
          .first
          .functions
          .first

      {node.from.line, node.from.column}.should eq({2, 2})

      # actually {4, 2} but all parsers go over by 1
      {node.to.line, node.to.column}.should eq({4, 3})

      # First line
      node.contains?(2, 1).should be_false # space before `f`
      node.contains?(2, 3).should be_true  # `f` of `fun`

      # Middle line
      node.contains?(3, 0).should be_true
      node.contains?(3, 9).should be_true
      node.contains?(3, 1000).should be_true

      # End line
      node.contains?(4, 2).should be_true  # `}`
      node.contains?(4, 3).should be_false # space after `}`
    end
  end
end
