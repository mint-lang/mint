module Mint
  class SourceUrl
    def self.parse_user_and_repo(url : String) : Tuple(String, String)
      if /[https?:\/\/]?(.*)\.(.*)\/(.*)\/(.*)\/?/.match(url)
        {$3, $4}
      else
        {"", ""}
      end
    end
  end
end
