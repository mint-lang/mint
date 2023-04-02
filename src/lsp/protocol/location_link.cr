module LSP
    struct LocationLink
      include JSON::Serializable
  
      @[JSON::Field(key: "originSelectionRange")]
      property origin_selection_range : Range
  
      @[JSON::Field(key: "targetUri")]
      property target_uri : String
  
      @[JSON::Field(key: "targetRange")]
      property target_range : Range
  
      @[JSON::Field(key: "targetSelectionRange")]
      property target_selection_range : Range
  
      def initialize(@origin_selection_range, @target_uri, @target_range, @target_selection_range)
      end
    end
  end
  