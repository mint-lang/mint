require "./spec_helper"

context "Clean" do
  it "cleans the temporary directory" do
    FileUtils.mkdir ".mint"
    FileUtils.mkdir "dist"

    expect_output ["clean"], <<-TEXT
      Mint - Removing directories
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Deleting: .mint
      Deleting: dist
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "cleans the package cache directory" do
    FileUtils.mkdir Mint::MINT_PACKAGES_DIR

    expect_output ["clean", "--package-cache"], <<-TEXT
      Mint - Removing directories
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Deleting: ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "nothing to delete" do
    expect_output ["clean"], <<-TEXT
      Mint - Removing directories
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Nothing to delete.
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "prints the help" do
    expect_output ["clean", "--help"], <<-TEXT
      Usage:
        ×××× clean [flags...] [arg...]

      Removes artifacts (directories) created by Mint.

      Flags:
        --help           # Displays help for the current command.
        --package-cache  # If specified, cleans the package cache directory.
      TEXT
  end
end
