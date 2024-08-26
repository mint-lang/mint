require "./spec_helper"

context "build" do
  before_each do
    FileUtils.rm_rf "my-project"
    run ["init", "my-project"]
    FileUtils.cd "my-project"
  end

  after_each do
    FileUtils.cd ".."
    FileUtils.rm_rf "my-project"
  end

  it "generates documentation" do
    expect_output ["docs"], <<-TEXT
      Mint - Documentation Generator
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ⚙ Clearing the "docs" directory... ×××××
      ⚙ Generating documentation... ×××××
      ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      All done in ××××!
      TEXT
  end
end
