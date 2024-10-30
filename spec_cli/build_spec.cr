require "./spec_helper"

context "build" do
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
    expect_output ["build", "--help"], <<-TEXT
      Usage:
        ×××× build [flags...] [arg...]

      Builds the project for production.

      Flags:
        --env, -e            # Loads the given .env file.
        --generate-manifest  # If specified, the web manifest will be generated.
        --help               # Displays help for the current command.
        --no-optimize        # If specified, the resulting JavaScript code will not be optimized.
        --runtime            # If specified, the supplied runtime will be used instead of the default.
        --skip-icons         # If specified, the application icons will not be generated.
        --timings            # If specified, timings will be printed.
        --verbose            # If specified, all written files will be logged.
        --watch, -w          # If specified, will build on every change.
      TEXT
  end

  it "builds the project" do
    expect_output ["build"], <<-TEXT
      Mint - Building for production
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "dist" directory... ××××
      ⚙ Building... ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Bundle size: ××××KB
      Files: 10
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "shows timings with the `--timings` flag" do
    expect_output ["build", "--timings"], <<-TEXT
      Mint - Building for production
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "dist" directory... ××××
      ⚙ Building... ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Bundle size: ××××KB
      Files: 10
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Parsing files                              | ××××
      Type Checking                              | ××××
      Building application                       | ××××
        Compiling intermediate representation... | ××××
        Calculating dependencies for bundles...  | ××××
        Bundling and generating JavaScript...    | ××××
      Generating index.html                      | ××××
      Generating icons                           | ××××
      Copying assets                             | ××××
      Generating index.css                       | ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "generates manifeset with the `--generate-manifest` flag" do
    expect_output ["build", "--generate-manifest"], <<-TEXT
      Mint - Building for production
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "dist" directory... ××××
      ⚙ Building... ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Bundle size: ××××KB
      Files: 11
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT

    File.exists?("dist/manifest.webmanifest").should eq(true)
  end

  it "logs the files using the `--verbose` flag" do
    expect_output ["build", "--verbose"], <<-TEXT
      Mint - Building for production
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "dist" directory... ××××
      ⚙ Building... ××××
      ⚙ Writing __mint__/bottom-center_65d9d8fd7df4b3a35b1902a81cdbda84.png (38.1KB)... ××××
      ⚙ Writing __mint__/bottom-right_6af458c30624b5e5fb037d8b85e80d97.png (62.4KB)... ××××
      ⚙ Writing __mint__/bottom-left_56d5c8f1ad148a45a63fc5c092d096c6.png (52.0KB)... ××××
      ⚙ Writing __mint__/top-center_68582b5008e9414b7a5c8faf7758bd32.png (36.2KB)... ××××
      ⚙ Writing __mint__/top-right_b74c8a753f67cde5e97e6fbb5ec63c52.png (60.6KB)... ××××
      ⚙ Writing __mint__/top-left_50246e01096cfd733510104620d52c8e.png (48.1KB)... ××××
      ⚙ Writing __mint__/runtime.js (××××KB)... ××××
      ⚙ Writing __mint__/index.css (1.46KB)... ××××
      ⚙ Writing __mint__/index.js (9.54KB)... ××××
      ⚙ Writing index.html (924B)... ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Bundle size: ××××KB
      Files: 10
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
