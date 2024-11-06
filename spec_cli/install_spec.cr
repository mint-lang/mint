require "./spec_helper"

context "install" do
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
    expect_output ["install", "--help"], <<-TEXT
      Usage:
        ×××× install [flags...] [arg...]

      Installs dependencies.

      Flags:
        --help  # Displays help for the current command.
      TEXT
  end

  it "no dependencies" do
    expect_output ["install"], <<-TEXT
      Mint - Installing dependencies
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      There are no dependencies!
      There is nothing to do!
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
