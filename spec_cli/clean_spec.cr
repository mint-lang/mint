require "./spec_helper"

context "clean" do
  before_all do
    FileUtils.rm_rf Mint::MINT_PACKAGES_DIR
    FileUtils.rm_rf ".mint"
    FileUtils.rm_rf "dist"
  end

  it "displays help with '--help' flag" do
    expect_output ["tool", "clean", "--help"], <<-TEXT
      Usage:
        ×××× tool clean [flags...] [arg...]

      Removes artifacts (directories) created by Mint.

      Flags:
        --help           # Displays help for the current command.
        --package-cache  # If specified, cleans the package cache directory.
      TEXT
  end

  it "cleans the temporary directory" do
    FileUtils.mkdir ".mint"
    FileUtils.mkdir "dist"

    expect_output ["tool", "clean"], <<-TEXT
      Mint - Removing directories
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Deleting: .mint
      Deleting: dist
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  {% if flag?(:linux) %}
    it "cleans the package cache directory" do
      FileUtils.mkdir Mint::MINT_PACKAGES_DIR

      expect_output ["tool", "clean", "--package-cache"], <<-TEXT
      Mint - Removing directories
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Deleting: ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
    end
  {% end %}

  it "nothing to delete" do
    expect_output ["tool", "clean"], <<-TEXT
      Mint - Removing directories
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Nothing to delete.
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
