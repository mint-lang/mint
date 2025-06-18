module Mint
  class Compiler
    def compile(node : Ast::Builtin) : Compiled
      compile node do
        case node.value
        when "decodeBoolean"
          [Builtin::DecodeBoolean] of Item
        when "decodeNumber"
          [Builtin::DecodeNumber] of Item
        when "decodeString"
          [Builtin::DecodeString] of Item
        when "decodeArray"
          [Builtin::DecodeArray] of Item
        when "decodeField"
          [Builtin::DecodeField] of Item
        when "decodeMaybe"
          [Builtin::DecodeMaybe] of Item
        when "decodeTime"
          [Builtin::DecodeTime] of Item
        when "locale"
          [Builtin::Locale, ".value"] of Item
        when "normalizeEvent"
          [Builtin::NormalizeEvent] of Item
        when "createPortal"
          [Builtin::CreatePortal] of Item
        when "testContext"
          [Builtin::TestContext] of Item
        when "testRender"
          [Builtin::TestRender] of Item
        when "setLocale"
          [Builtin::SetLocale] of Item
        when "compare"
          [Builtin::Compare] of Item
        when "inspect"
          [Builtin::Inspect] of Item
        when "navigate"
          if config.hash_routing
            [Builtin::NavigateHash] of Item
          else
            [Builtin::Navigate] of Item
          end
        when "href"
          if config.hash_routing
            [Builtin::HrefHash] of Item
          else
            [Builtin::Href] of Item
          end
        when "nothing"
          nothing
        when "just"
          just
        when "err"
          err
        when "ok"
          ok
        else
          [] of Item
        end
      end
    end
  end
end
