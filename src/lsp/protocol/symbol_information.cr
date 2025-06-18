module LSP # Represents information about programming constructs like variables, classes,
  # interfaces etc.
  class SymbolInformation
    include JSON::Serializable

    # The kind of this symbol.
    @[JSON::Field(converter: Enum::ValueConverter(LSP::SymbolKind))]
    getter kind : SymbolKind

    # The location of this symbol. The location's range is used by a tool
    # to reveal the location in the editor. If the symbol is selected in the
    # tool the range's start information is used to position the cursor. So
    # the range usually spans more than the actual symbol's name and does
    # normally include things like visibility modifiers.
    #
    # The range doesn't have to denote a node range in the sense of an abstract
    # syntax tree. It can therefore not be used to re-construct a hierarchy of
    # the symbols.
    getter location : Location

    # The name of this symbol.
    getter name : String

    def initialize(
      @name : String,
      @kind : SymbolKind,
      @location : Location,
    )
    end
  end
end
