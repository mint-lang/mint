require "../spec_helper"

context "docs-json" do
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
    expect_output ["tool", "docs-json", "--help"], <<-TEXT
      Usage:
        ×××× tool docs-json [flags...] <output> [arg...]

      Generates API Documentation in JSON format.

      Flags:
        --help              # Displays help for the current command.
        --include-core      # If specified, documentation will be generated for the standard library as well.
        --include-packages  # If specified, documentation will be generated for used packages as well.
        --pretty            # If specified, the JSON will be pretty printed.

      Arguments:
        output (required)   # The output file to save it to.
      TEXT
  end

  it "generates documentation" do
    expect_output ["tool", "docs-json"], <<-TEXT
      Mint - Generating JSON documentation
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Generated documentation.
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "generates documentation (with flags)" do
    expect_output ["tool", "docs-json", "--pretty", "--include-core", "--include-packages"], <<-TEXT
      Mint - Generating JSON documentation
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Generated documentation.
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
