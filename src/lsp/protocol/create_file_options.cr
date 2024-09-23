module LSP
  struct CreateFileOptions
    include JSON::Serializable

    # Overwrite existing file. Overwrite wins over `ignoreIfExists`
    property overwrite : Bool?

    # Ignore if exists.
    @[JSON::Field(key: "ignoreIfExists")]
    property ignore_if_exists : Bool?
  end
end
