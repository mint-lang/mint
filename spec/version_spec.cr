require "./spec_helper"
require "yaml"

describe "Mint::VERSION" do
  it "matches version defined in shard.yml" do
    contents = File.read(File.expand_path("../../shard.yml", __FILE__))
    meta = YAML.parse(contents)

    meta["version"]?.should_not be_falsey
    Mint::VERSION.should eq(meta["version"].as_s)
  end
end
