require "yaml"
require "./spec_helper"

describe Mint::VERSION do
  it "should match shard.yml" do
    version = YAML.parse(File.read(Path[__DIR__, "..", "shard.yml"]))["version"].as_s
    version.should eq Mint::VERSION
  end
end
