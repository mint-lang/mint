require "./spec_helper"

context "Version" do
  it "prints the version" do
    expect_output ["version"], "Mint #{Mint.version}"
  end

  it "prints the help" do
    expect_output ["version", "--help"], <<-TEXT
      Usage:
        ×××× version [flags...] [arg...]

      Shows version.

      Flags:
        --help  # Displays help for the current command.
      TEXT
  end
end
