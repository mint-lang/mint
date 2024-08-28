require "./spec_helper"

context "docs" do
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
    expect_output ["docs", "--help"], <<-TEXT
      Usage:
        ×××× docs [flags...] <directory> [arg...]

      Generates API Documentation.

      Flags:
        --help                # Displays help for the current command.
        --include-core        # If specified, documentation will be generated for the standard library as well.
        --include-packages    # If specified, documentation will be generated for used packages as well.

      Arguments:
        directory (required)  # The directory to generate the docs to.
      TEXT
  end

  it "generates documentation" do
    expect_output ["docs"], <<-TEXT
      Mint - Generating documentation
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "docs" directory... ×××××
      ⚙ Generating documentation... ×××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "generates documentation (with flags)" do
    expect_output ["docs", "--include-core", "--include-packages"], <<-TEXT
      Mint - Generating documentation
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "docs" directory... ×××××
      ⚙ Generating documentation... ×××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
