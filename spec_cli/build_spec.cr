require "./spec_helper"

context "build" do
  before_each do
    run ["init", "my-project"]
    FileUtils.cd "my-project"
  end

  after_each do
    FileUtils.cd ".."
    FileUtils.rm_rf "my-project"
  end

  it "builds the project" do
    expect_output ["build"], <<-TEXT
      Mint - Building for production...
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Building for production...
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "dist" directory... ××××
      ⚙ Building... ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Bundle size: 359KB
      Files: 10
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "shows timings with the `--timings` flag" do
    expect_output ["build", "--timings"], <<-TEXT
      Mint - Building for production...
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Building for production...
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "dist" directory... ××××
      ⚙ Building... ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Bundle size: 359KB
      Files: 10
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Parsing files                              | ××××
      Type Checking                              | ××××
      Building application                       | ××××
        Compiling intermediate representation... | ××××
        Calculating dependencies for bundles...  | ××××
        Bundling and rendering JavaScript...     | ××××
      Generating index.html                      | ××××
      Generating icons                           | ××××
      Copying assets                             | ××××
      Building index.css                         | ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end

  it "generates manifeset with the `--generate-manifest` flag" do
    expect_output ["build", "--generate-manifest"], <<-TEXT
      Mint - Building for production...
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Building for production...
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "dist" directory... ××××
      ⚙ Building... ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Bundle size: 359KB
      Files: 11
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT

    File.exists?("dist/manifest.webmanifest").should eq(true)
  end

  it "logs the files using the `--verbose` flag" do
    expect_output ["build", "--verbose"], <<-TEXT
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Building for production...
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "dist" directory... ××××
      ⚙ Building... ××××
      ⚙ Writing __mint__/bottom-center_65d9d8fd7df4b3a35b1902a81cdbda84.png (38.1KB)... ××××
      ⚙ Writing __mint__/bottom-right_6af458c30624b5e5fb037d8b85e80d97.png (62.4KB)... ××××
      ⚙ Writing __mint__/bottom-left_56d5c8f1ad148a45a63fc5c092d096c6.png (52.0KB)... ××××
      ⚙ Writing __mint__/top-center_68582b5008e9414b7a5c8faf7758bd32.png (36.2KB)... ××××
      ⚙ Writing __mint__/top-right_b74c8a753f67cde5e97e6fbb5ec63c52.png (60.6KB)... ××××
      ⚙ Writing __mint__/top-left_50246e01096cfd733510104620d52c8e.png (48.1KB)... ××××
      ⚙ Writing __mint__/runtime.js (49.6KB)... ××××
      ⚙ Writing __mint__/index.css (1.46KB)... ××××
      ⚙ Writing __mint__/index.js (9.54KB)... ××××
      ⚙ Writing index.html (899B)... ××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      Bundle size: 359KB
      Files: 10
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
