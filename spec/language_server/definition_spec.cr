require "../spec_helper"

def clean_json(workspace : Workspace, path : String)
  path.strip.gsub("\#{root_path}", workspace.root_path)
end

Dir
  .glob("./spec/language_server/definition/**/*")
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
            raise Exception.new("Unknown manifest type #{match[1].inspect}, expected file, request or response")
          end

          position = match.end
        end

        raise Exception.new("Expected requests") if requests.empty?
        raise Exception.new("Expected responses") if responses.empty?

        results = lsp_json(requests)

        begin
          results.last.should eq(responses[0])
        rescue error
          fail diff(responses[0], results.last)
        end
      end
    end
  end
