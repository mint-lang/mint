class Ast
  class Record < Node
    getter fields

    UNIT = new(
      fields: [] of RecordField,
      input: Data.new("", ""),
      from: 0,
      to: 2)

    def initialize(@fields : Array(RecordField),
                   @input : Data,
                   @from : Int32,
                   @to : Int32)
    end

    def self.empty
      UNIT
    end
  end
end
