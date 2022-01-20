module LSP
  # Enum of known range kinds
  enum FoldingRangeKind
    # Folding range for a comment
    Comment

    # Folding range for a imports or includes
    Imports

    # Folding range for a region (e.g. `#region`)
    Region
  end
end
