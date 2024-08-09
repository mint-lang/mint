require "./spec_helper"

context "Format" do
  before_each do
    FileUtils.rm_rf "source.mint"
  end

  after_each do
    FileUtils.rm_rf "source.mint"
  end

  formatted_code =
    <<-MINT
    type Test {
      file : String
    }
    MINT

  unformatted_code =
    <<-MINT
    typeTest{file:String}
    MINT

  it "prints the help" do
    expect_output ["format", "--help"], <<-TEXT
      Usage:
        ×××× format [flags...] <pattern> [arg...]

      Formats *.mint files.

      Flags:
        --check  # Checks that formatting code produces no changes.
        --help   # Displays help for the current command.
        --stdin  # Formats code from STDIN and writes it to STDOUT.

      Arguments:
        pattern  # The pattern which determines which files to format.
      TEXT
  end

  it "formats code from STDIN" do
    expect_output ["format", "--stdin"], <<-TEXT, unformatted_code
      type Test {
        file : String
      }
      TEXT
  end

  it "check code from STDIN (not formatted)" do
    expect_output ["format", "--stdin", "--check"], <<-TEXT, unformatted_code
      Mint - Checking source from STDIN
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Source is not formatted!
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      There was an error, exiting...
      TEXT
  end

  it "check code from STDIN (formatted)" do
    expect_output ["format", "--stdin", "--check"], <<-TEXT, formatted_code + "\n"
      Mint - Checking source from STDIN
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Source is formatted!
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "nothing to format" do
    expect_output ["format"], <<-TEXT
      Mint - Formatting files
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Nothing to format!
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "formatted files" do
    File.write("source.mint", unformatted_code)

    expect_output ["format", "source.mint"], <<-TEXT
      Mint - Formatting files
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Formatted: source.mint
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "not formatted (--check)" do
    File.write("source.mint", unformatted_code)

    expect_output ["format", "source.mint", "--check"], <<-TEXT
      Mint - Formatting files
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Not formatted: source.mint
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "all files formatted" do
    File.write("source.mint", formatted_code + "\n")

    expect_output ["format", "source.mint"], <<-TEXT
      Mint - Formatting files
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All files are formatted!
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
