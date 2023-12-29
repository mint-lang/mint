module Mint
  class Compiler2
    record Config,
      runtime_path : String,
      css_prefix : String?,
      relative : Bool,
      optimize : Bool,
      build : Bool
  end
end
