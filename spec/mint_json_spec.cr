require "./spec_helper"

Dir
  .glob("./spec/mint_json/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    it file do
      source, expected =
        File.read(file).split("-" * 80)

      begin
        Mint::MintJson.parse(contents: source, path: "spec/fixtures/mint.json")
      rescue error : Mint::Error
        result =
          error.to_terminal.to_s.uncolorize

        fail diff(expected, result) unless result == expected.strip
      end
    end
  end

it "non existent file" do
  begin
    Mint::MintJson.parse("test.json")
  rescue error : Mint::Error
    error.to_terminal.to_s.uncolorize.should eq(<<-TEXT)
      ░ ERROR (MINT_JSON_INVALID) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

      There was a problem trying to open a mint.json file: test.json

        Error opening file with mode 'r': 'test.json': No such file or directory
      TEXT
  end
end

it "no mint.json in directory or parents" do
  begin
    Mint::MintJson.parse("test.json", search: true)
  rescue error : Mint::Error
    error.to_terminal.to_s.uncolorize.should eq(<<-TEXT)
      ░ ERROR (MINT_JSON_NOT_FOUND) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

      I could not find a mint.json file in the path or any of its parent directories:

        test.json
      TEXT
  end
end
