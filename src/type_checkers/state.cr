module Mint
  class TypeChecker
    type_error StateNotFoundRecord
    type_error StateRecordMismatch

    def check(node : Ast::State) : Type
      record =
        resolve node.type

      type =
        resolve node.data

      raise StateRecordMismatch, {
        "expected" => record,
        "node"     => node.data,
        "got"      => type,
      } unless Comparer.compare(record, type)

      type
    rescue error : RecordNotFoundMatchingRecord
      raise StateNotFoundRecord, {
        "record" => error.locals["structure"],
        "node"   => node.data,
      }
    end
  end
end
