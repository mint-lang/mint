require "./spec_helper"

def clean_json(workspace : Workspace, path : String)
  path.strip.gsub("\#{root_path}", workspace.root_path)
end

Dir
  .glob("./spec/language_server/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      with_workspace do |workspace|
        contents = File.read(file)

        position = 0

        requests = [] of String
        responses = [] of {String, Int32 | Nil, String}

        contents.scan(/^\-+(\w+)( [\w\-.]+)?( [\w\-.]+)?/m) do |match|
          text =
            contents[position, match.begin - position].strip

          case match[1]
          when "file"
            workspace.file match[2].strip, text
          when "request"
            requests << clean_json(workspace, text)
          when "response"
            id, param =
              if value = match[3]?.try(&.strip)
                {match[2]?.to_s.strip, value}
              else
                {"", match[2]?.to_s.strip}
              end

            responses << {
              clean_json(workspace, text),
              id.to_i32?,
              param,
            }
          else
            raise Exception.new("Unknown type #{match[1].inspect}, expected file, request or response")
          end

          position = match.end
        end

        raise Exception.new("Expected requests") if requests.empty?

        actual_responses = lsp_json(requests)

        if responses.size > 0
          responses.each do |expected_response|
            expected_id =
              expected_response[1] ||
                JSON.parse(expected_response[0])["id"].as_i?

            actual_response =
              actual_responses.find! do |response|
                JSON.parse(response)["id"].as_i? == expected_id
              end

            case expected_response[2]
            when "contain"
              json =
                JSON.parse(actual_response)

              expected =
                JSON.parse(expected_response[0])

              json.to_json.should contain(expected.to_json)
            else
              begin
                expected_response[0].should eq(actual_response)
              rescue error
                fail diff(expected_response[0], actual_response)
              end
            end
          end
        elsif actual_responses.size > 0
          puts actual_responses
          raise Exception.new("No responses expected")
        end
      end
    end
  end
