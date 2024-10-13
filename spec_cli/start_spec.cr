require "./spec_helper"

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
    expect_output ["start", "--help"], <<-TEXT
      Usage:
        ×××× start [flags...] [arg...]

      Starts the development server.

      Flags:
        --env, -e                                            # Loads the given .env file.
        --format                                             # Formats the source files when they change.
        --help                                               # Displays help for the current command.
        --host, -h (default: ENV["HOST"]? || "0.0.0.0")      # The host to serve the application on.
        --no-reload                                          # Do not reload the browser when something changes.
        --port, -p (default: (ENV["PORT"]? || "3000").to_i)  # The port to serve the application on.
        --runtime                                            # If specified, the supplied runtime will be used instead of the default.
      TEXT
  end
end
