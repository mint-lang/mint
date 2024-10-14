require "../spec_helper"

context "test" do
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
    expect_output ["tool", "docs-server", "--help"], <<-TEXT
      Usage:
        ×××× tool docs-server [flags...] [arg...]

      API Documentation Server.

      Flags:
        --help                                               # Displays help for the current command.
        --host, -h (default: ENV["HOST"]? || "0.0.0.0")      # The host to serve the documentation on.
        --port, -p (default: (ENV["PORT"]? || "3002").to_i)  # The port to serve the documentation on.
      TEXT
  end
end
