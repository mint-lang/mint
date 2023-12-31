module Mint
  class Compiler2
    record Config,
      test : Tuple(String, String)?,
      include_program : Bool,
      runtime_path : String,
      css_prefix : String?,
      relative : Bool,
      optimize : Bool,
      build : Bool
  end
end
