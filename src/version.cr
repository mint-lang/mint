module Mint
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
end
