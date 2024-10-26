module Mint
  def self.version
    {{ `shards version "#{__DIR__}"`.chomp.stringify }}
  end
end
