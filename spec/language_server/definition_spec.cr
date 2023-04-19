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
        request, response = nil, nil

        contents.scan(/^\-+(\w+)( [\w.]+)?/m) do |match|
          text = contents[position, match.begin - position]

          case match[1]
          when "file"
            workspace.file match[2].strip, text.strip
          when "request"
            request = clean_json(workspace, text)
          when "response"
            response = clean_json(workspace, text)
          else
            raise Exception.new("Unknown manifest type #{match[1].inspect}, expected file, request or response")
          end

          position = match.end
        end

        raise Exception.new("Expected request") if request.nil?
        raise Exception.new("Expected response") if response.nil?

        result = lsp_json(request)

        begin
          result.should eq(response)
        rescue error
          fail diff(response, result)
        end
      end
    end
  end
