require "./spec_helper"

context "lints" do
  before_all do
    FileUtils.rm_rf "my-project"
    run ["init", "my-project"]
    FileUtils.cd "my-project"
  end

  after_all do
    FileUtils.cd ".."
    FileUtils.rm_rf "my-project"
  end

  it "displays help with '--help' flag" do
    expect_output ["lint", "--help"], <<-TEXT
      Usage:
        ×××× lint [flags...] [arg...]

      Lints the project for syntax and type errors.

      Flags:
        --help  # Displays help for the current command.
        --json  # Output errors in a JSON format.
      TEXT
  end

  it "no errors" do
    expect_output ["lint"], <<-TEXT
      Mint - Linting
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      No errors or warnings detected.
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "parse error" do
    File.write("source/Main.mint", "asd")

    expect_output ["lint"], <<-TEXT
      Mint - Linting
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ░ ERROR (EXPECTED_EOF) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

      I was expecting the end of the file but I found "asd" instead:

         ┌ source/Main.mint:1:1
         ├─────────────────────
        1│ asd

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "type error" do
    File.write("source/Main.mint", "component Main { property test : String }")

    expect_output ["lint"], <<-TEXT
      Mint - Linting
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ░ ERROR (COMPONENT_MAIN_PROPERTIES) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

      The Main component cannot have properties because there is no way to pass values
      to them.

      A property is defined here:

         ┌ source/Main.mint:1:18
         ├──────────────────────────────────────────
        1│ component Main { property test : String }

      The component in question is here:

         ┌ source/Main.mint:1:1
         ├──────────────────────────────────────────
        1│ component Main { property test : String }

      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
