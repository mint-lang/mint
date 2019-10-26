require "./spec_helper"

describe Mint::NamePool do
  it "returns nex name" do
    pool = Mint::NamePool(String, Mint::StyleBuilder::Selector).new
    object = Mint::StyleBuilder::Selector.new

    pool.of("a", object).should eq("a")
    pool.of("a", object).should eq("a")
    pool.of("b", object).should eq("b")
    pool.of("c", object).should eq("c")
  end
end
