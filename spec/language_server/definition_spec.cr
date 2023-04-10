require "../spec_helper"

Dir
  .glob("./spec/language_server/definition/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      with_workspace do |workspace|
        manifest, *rest = File.read(file).split("-" * 80)

        request, response = nil, nil

        manifest.lines.each_with_index do |line, index|
          raise Exception.new("Expected manifest line, got #{line.inspect}") unless md = /(\w+)( [\w.]+)?/.match(line)

          case md[1]
          when "file"
            workspace.file md[2].strip, rest[index].strip
          when "request"
            request = rest[index].strip.gsub("\#{root}", workspace.root_path)
          when "response"
            response = rest[index].strip.gsub("\#{root}", workspace.root_path)
          else
            raise Exception.new("Unknown manifest type #{line.inspect}, expected file, request or response")
          end
        end

        raise Exception.new("Expected request") if request.nil?
        raise Exception.new("Expected response") if response.nil?

        result = lsp2(request)

        begin
          result.should eq(response)
        rescue error
          fail diff(response, result)
        end
      end
    end
  end
