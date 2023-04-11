require "../spec_helper"

describe "Language Server Protocol - Message Parser" do
  context "failures" do
    it "raises error on EOF" do
      empty_io = IO::Memory.new

      expect_raises(IO::EOFError) do
        LSP::MessageParser.parse(empty_io) { }
      end
    end
  end

  context "successes" do
    it "parses a single message" do
      body = {
        jsonrpc: "2.0",
        id:      1,
        params:  {field1: 1, field2: 2},
        method:  "example/action",
      }.to_json

      io = IO::Memory.new
      io.print "Invalid-Header: Invalid\r\n"
      io.print "Content-Length: #{body.bytesize}\r\n"
      io.print "\r\n"
      io.print body
      io.rewind

      content = LSP::MessageParser.parse(io, &.itself)
      content.should eq(body)
    end
  end
end
