require "./spec_helper"

describe "JS" do
  context "Optimized" do
    optimized = Mint::Js.new(true)

    context "object" do
      it "renders object Optimized" do
        subject =
          optimized.object({"a" => "b", "c" => "d"})

        result =
          Mint::Codegen.build(subject)[:code]

        result.should eq("{a:b,c:d}")
      end
    end
  end
end
