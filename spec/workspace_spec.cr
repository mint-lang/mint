require "./spec_helper"

describe Mint::Workspace do
  it "notifies immediately (success)" do
    with_workspace do |workspace|
      workspace.file("Main.mint", "")

      results =
        [] of Mint::TypeChecker | Mint::Error

      Mint::Workspace.new(
        listener: ->(result : Mint::Workspace::Result) { results << result.value },
        path: Path[workspace.root_path, "mint.json"].to_s,
        check: Mint::Check::Environment,
        include_tests: false,
        dot_env: ".env",
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
        listener: ->(result : Mint::Workspace::Result) { results << result.value },
        check: Mint::Check::Environment,
        path: workspace.root_path,
        include_tests: false,
        dot_env: ".env",
        format: false)

      results.size.should eq(1)
      results[0].should be_a(Mint::Error)
    end
  end

  it "warns about unused locale keys" do
    with_workspace do |workspace|
      workspace.file("Main.mint", <<-MINT)
        locale en {
          test: "Hello"
        }

        locale fr {
          test: "Bonjour"
        }

        component Main {
          fun render : Html {
            <div>"Hello"</div>
          }
        }
        MINT

      warnings = [] of Mint::Warning

      Mint::Workspace.new(
        listener: ->(result : Mint::Workspace::Result) { warnings = result.warnings },
        path: Path[workspace.root_path, "mint.json"].to_s,
        check: Mint::Check::Environment,
        include_tests: false,
        dot_env: ".env",
        format: false)

      warnings.size.should eq(1)
      warnings[0].name.should eq(:unused_locale_key)
    end
  end

  it "does not warn about used locale keys" do
    with_workspace do |workspace|
      workspace.file("Main.mint", <<-MINT)
        locale en {
          test: "Hello"
        }

        component Main {
          fun render : Html {
            <div>:test</div>
          }
        }
        MINT

      warnings = [] of Mint::Warning

      Mint::Workspace.new(
        listener: ->(result : Mint::Workspace::Result) { warnings = result.warnings },
        path: Path[workspace.root_path, "mint.json"].to_s,
        check: Mint::Check::Environment,
        include_tests: false,
        dot_env: ".env",
        format: false)

      warnings.should be_empty
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
        listener: ->(result : Mint::Workspace::Result) { results << result.value },
        path: Path[workspace.root_path, "mint.json"].to_s,
        check: Mint::Check::Environment,
        include_tests: false,
        dot_env: ".env",
        format: false)

      FileUtils.touch(Path[workspace.root_path, "Main.mint"])
      FileUtils.touch(Path[workspace.root_path, "File1.mint"])
      FileUtils.touch(Path[workspace.root_path, "File2.mint"])

      sleep 1.seconds

      results.size.should eq(2)
    end
  end
end
