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
    expect_output ["test", "--help"], <<-TEXT
      Usage:
        ×××× test [flags...] <test> [arg...]

      Runs the tests defined for the project.

      Flags:
        --browser, -b (default: "chrome")                                    # Which browser to run the tests in (chrome, firefox).
        --browser-host, -x (default: ENV["BROWSER_HOST"]? || "127.0.0.1")    # Target host, useful when hosted on another machine.
        --browser-port, -c (default: (ENV["BROWSER_PORT"]? || "3001").to_i)  # Target port, useful when hosted on another machine.
        --env, -e                                                            # Loads the given .env file.
        --help                                                               # Displays help for the current command.
        --host, -h (default: ENV["HOST"]? || "127.0.0.1")                    # Host to serve the tests on.
        --manual, -m                                                         # Start the test server for manual testing.
        --port, -p (default: (ENV["PORT"]? || "3001").to_i)                  # Port to serve the tests on.
        --reporter, -r (default: "dot")                                      # Which reporter to use (dot, documentation),
        --runtime                                                            # If specified, the supplied runtime will be used instead of the default.
        --watch, -w                                                          # Watch files for changes and rerun tests.

      Arguments:
        test                                                                 # The path to the test file to run.
      TEXT
  end

  it "runs the tests" do
    expect_output ["test"], clear_env: false, template: <<-TEXT
      Mint - Running tests
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Starting browser...
      ⚙ Test server started: http://127.0.0.1:3001/
      ⚙ Running tests:
      .
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      1 tests
        ➔ 1 passed
        ➔ 0 failed
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
