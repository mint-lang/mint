require "./spec_helper"

describe Mint::Workspace do
  it "notifies immediately (success)" do
    with_workspace do |workspace|
      workspace.file("Main.mint", "")

      results =
        [] of Mint::TypeChecker | Mint::Error

      Mint::Workspace.new(
        listener: ->(item : Mint::TypeChecker | Mint::Error) { results << item },
        path: Path[workspace.root_path, "mint.json"].to_s,
        check: Mint::Check::Environment,
        include_tests: false,
        format: false)

      results.size.should eq(1)
      results[0].should be_a(Mint::TypeChecker)
    end
  end

  it "notifies immediately (error - no mint.json found)" do
    with_workspace do |workspace|
      results =
        [] of Mint::TypeChecker | Mint::Error

      Mint::Workspace.new(
        listener: ->(item : Mint::TypeChecker | Mint::Error) { results << item },
        check: Mint::Check::Environment,
        path: workspace.root_path,
        include_tests: false,
        format: false)

      results.size.should eq(1)
      results[0].should be_a(Mint::Error)
    end
  end

  it "notifies after change (success)" do
    with_workspace do |workspace|
      workspace.file("Main.mint", "")
      workspace.file("File1.mint", "")
      workspace.file("File2.mint", "")

      results =
        [] of Mint::TypeChecker | Mint::Error

      Mint::Workspace.new(
        listener: ->(item : Mint::TypeChecker | Mint::Error) { results << item },
        path: Path[workspace.root_path, "mint.json"].to_s,
        check: Mint::Check::Environment,
        include_tests: false,
        format: false)

      FileUtils.touch(Path[workspace.root_path, "Main.mint"])
      FileUtils.touch(Path[workspace.root_path, "File1.mint"])
      FileUtils.touch(Path[workspace.root_path, "File2.mint"])

      sleep 1.seconds

      results.size.should eq(2)
    end
  end
end
