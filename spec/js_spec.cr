require "./spec_helper"

describe "JS" do
  context "Optimized" do
    optimized = Mint::Js.new(true)

    context "object" do
      it "renders object Optimized" do
        optimized.object({"a" => "b", "c" => "d"}).should eq("{a:b,c:d}")
      end
    end
  end
end
