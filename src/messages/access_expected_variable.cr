class Messages
  class AccessExpectedVariable
    def build
      [
        title("Syntax Error"),
        text("I was looking for the name of the field of the record but found #{got} instead."),
        snippet node,
      ]
    end
  end
end
