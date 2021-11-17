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

      location =
        Mint::Parser
          .parse(example, "example.mint")
          .components
          .first
          .functions
          .first
          .location

      location.start.should eq({2, 2})

      # actually {4, 2} but all parsers go over by 1
      location.end.should eq({4, 3})

      # First line
      location.contains?(2, 1).should eq(false) # space before `f`
      location.contains?(2, 3).should eq(true)  # `f` of `fun`

      # Middle line
      location.contains?(3, 0).should eq(true)
      location.contains?(3, 9).should eq(true)
      location.contains?(3, 1000).should eq(true)

      # End line
      location.contains?(4, 2).should eq(true)  # `}`
      location.contains?(4, 3).should eq(false) # space after `}`
    end
  end
end
