require "../spec_helper"

def clean_json(workspace : Workspace, path : String)
  path.strip.gsub("\#{root_path}", workspace.root_path)
end

Dir
  .glob("./spec/language_server/{hover,semantic_tokens}/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      with_workspace do |workspace|
        contents = File.read(file)

        position = 0

        requests = [] of String
        responses = [] of String

        contents.scan(/^\-+(\w+)( [\w.]+)?/m) do |match|
          text = contents[position, match.begin - position]

          case match[1]
          when "file"
            workspace.file match[2].strip, text.strip
          when "request"
            requests << clean_json(workspace, text)
          when "response"
            responses << clean_json(workspace, text)
          else
            raise Exception.new("Unknown type #{match[1].inspect}, expected file, request or response")
          end

          position = match.end
        end

        raise Exception.new("Expected requests") if requests.empty?
        raise Exception.new("Expected responses") if responses.empty?

        actual_responses = lsp_json(requests)

        responses.each do |expected_response|
          expected_id = JSON.parse(expected_response)["id"].as_i

          actual_response = actual_responses.find! do |response|
            JSON.parse(response)["id"].as_i == expected_id
          end

          begin
            expected_response.should eq(actual_response)
          rescue error
            fail diff(actual_response, expected_response)
          end
        end
      end
    end
  end
