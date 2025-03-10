require "./spec_helper"

context "init" do
  before_each do
    FileUtils.rm_rf "my-project"
  end

  after_each do
    FileUtils.rm_rf "my-project"
  end

  it "displays help with '--help' flag" do
    expect_output ["init", "--help"], <<-TEXT
      Usage:
        ×××× init [flags...] <name> [arg...]

      Initializes a new project.

      Flags:
        --bare  # If speficied, an empty project will be generated.
        --help  # Displays help for the current command.

      Arguments:
        name    # The name of the new project.
      TEXT
  end

  it "asks for a name if not provided" do
    expect_output(["init", "--bare"], <<-TEXT, "\nmy-project\n")
      Mint - Initializing a new project
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Please provide a name for the project (for example my-project):
      Please provide a name for the project (for example my-project):
      ⚙ Writing files:
        ➔ source
          ➔ Main.mint
        ➔ mint.json
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "initializes a project" do
    expect_output ["init", "my-project"], <<-TEXT
      Mint - Initializing a new project
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Writing files:
        ➔ assets
          ➔ bottom-center.png
          ➔ bottom-left.png
          ➔ bottom-right.png
          ➔ favicon.png
          ➔ head.html
          ➔ logo.svg
          ➔ top-center.png
          ➔ top-left.png
          ➔ top-right.png
        ➔ source
          ➔ Content.mint
          ➔ Main.mint
        ➔ tests
          ➔ Main.mint
        ➔ mint.json
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "directory already exists" do
    run ["init", "my-project"]

    expect_output ["init", "my-project"], <<-TEXT
      Mint - Initializing a new project
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚠ Directory exists, exiting...
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "initializes a project bare project with '--bare' flag" do
    expect_output ["init", "my-project", "--bare"], <<-TEXT
      Mint - Initializing a new project
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Writing files:
        ➔ source
          ➔ Main.mint
        ➔ mint.json
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
