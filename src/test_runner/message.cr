module Mint
  class TestRunner
    class Message
      struct Location
        include JSON::Serializable

        getter start : {Int64, Int64}
        getter end : {Int64, Int64}
        getter filename : String
      end

      include JSON::Serializable

      property location : Location?
      property result : String?
      property suite : String?
      property name : String?
      property type : String
    end
  end
end
