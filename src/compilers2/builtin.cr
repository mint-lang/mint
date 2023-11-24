module Mint
  class Compiler2
    def compile(node : Ast::Builtin) : Compiled
      compile node do
        case node.value
        when "normalizeEvent"
          [Builtin::NormalizeEvent] of Item
        when "decodeArray"
          [Builtin::DecodeArray] of Item
        when "decodeBoolean"
          [Builtin::DecodeBoolean] of Item
        when "decodeField"
          [Builtin::DecodeField] of Item
        when "decodeMaybe"
          [Builtin::DecodeMaybe] of Item
        when "decodeNumber"
          [Builtin::DecodeNumber] of Item
        when "decodeString"
          [Builtin::DecodeString] of Item
        when "decodeTime"
          [Builtin::DecodeTime] of Item
        when "navigate"
          [Builtin::Navigate] of Item
        when "compare"
          [Builtin::Compare] of Item
        when "just"
          [just] of Item
        when "nothing"
          [nothing] of Item
        when "err"
          [nothing] of Item
        when "ok"
          [nothing] of Item
        else
          raise "WTF"
        end
      end
    end
  end
end
