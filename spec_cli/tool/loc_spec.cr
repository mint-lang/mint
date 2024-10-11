require "../spec_helper"

context "highlight" do
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
    expect_output ["tool", "loc", "--help"], <<-TEXT
      Usage:
        ×××× tool loc [flags...] [arg...]

      Counts LOC (lines of code).

      Flags:
        --help  # Displays help for the current command.
      TEXT
  end

  it "displays lines of count" do
    expect_output ["tool", "loc"], <<-TEXT
      Mint - Counting lines of code
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Files: 2
      ⚙ Lines of code: 136
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
