module LSP
  struct CreateFileOptions
    include JSON::Serializable

    # Overwrite existing file. Overwrite wins over `ignoreIfExists`
    property overwrite : Bool?

    # Ignore if exists.
    property ignoreIfExists : Bool?
  end
end
