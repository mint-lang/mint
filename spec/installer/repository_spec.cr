require "../spec_helper"

tmp_dir = Mint::MINT_PACKAGES_DIR

describe "Repository" do
  context "failures" do
    context "json" do
      it "raises error on bad mint.json" do
        FileUtils.mkdir_p("#{tmp_dir}/success")
        File.write("#{tmp_dir}/success/mint.json", "hello")

        repository = Mint::Installer::Repository.new("name", "success")

        message = <<-MESSAGE
        ░ ERROR (REPOSITORY_INVALID_MINT_JSON) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

        I could not parse the mint.json for the package: name (success) for the version
        or tag: master
        MESSAGE

        begin
          repository.json("master")
          fail "Should have raised!"
        rescue error : Mint::Error
          error.to_terminal.to_s.uncolorize.should eq(message)
        end
      end

      it "raises error on no mint.json" do
        FileUtils.rm_rf("#{tmp_dir}/success")

        repository = Mint::Installer::Repository.new("name", "success")

        message = <<-MESSAGE
        ░ ERROR (REPOSITORY_NO_MINT_JSON) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

        I could not find the mint.json for the package: name (success) for the version
        or tag: master
        MESSAGE

        begin
          repository.json("master")
          fail "Should have raised!"
        rescue error : Mint::Error
          error.to_terminal.to_s.uncolorize.should eq(message)
        end
      end
    end

    it "raises error on git tag" do
      repository = Mint::Installer::Repository.new("name", "error")

      message = <<-MESSAGE
      ░ ERROR (REPOSITORY_COULD_NOT_GET_VERSIONS) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

      I could not get the tags of the repository: error

      The error I got from the git command is this:

      0.1.0
      0.2.0
      MESSAGE

      begin
        repository.versions
        fail "Should have raised!"
      rescue error : Mint::Error
        error.to_terminal.to_s.uncolorize.should eq(message)
      end
    end

    it "raises error on checkout" do
      repository = Mint::Installer::Repository.new("name", "error")

      message = <<-MESSAGE
      ░ ERROR (REPOSITORY_COULD_NOT_CHECKOUT) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

      I could not checkout the version or tag: master of the repository: error

      The error I got from the git command is this:

      checked out
      MESSAGE

      begin
        repository.checkout("master")
        fail "Should have raised!"
      rescue error : Mint::Error
        error.to_terminal.to_s.uncolorize.should eq(message)
      end
    end

    it "raises error on clone" do
      FileUtils.rm_rf("#{tmp_dir}/error")

      message = <<-MESSAGE
      ░ ERROR (REPOSITORY_COULD_NOT_CLONE) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

      I could not clone the repository: error

      The error I got from the git command is this:

      cloned
      MESSAGE

      begin
        Mint::Installer::Repository.open("name", "error")
        fail "Should have raised!"
      rescue error : Mint::Error
        error.to_terminal.to_s.uncolorize.should eq(message)
      end
    end

    it "raises error on update" do
      FileUtils.mkdir_p("#{tmp_dir}/error")

      message = <<-MESSAGE
      ░ ERROR (REPOSITORY_COULD_NOT_UPDATE) ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

      I could not update the repository: error

      The error I got from the git command is this:

      fetched
      MESSAGE

      begin
        Mint::Installer::Repository.open("name", "error")
        fail "Should have raised!"
      rescue error : Mint::Error
        error.to_terminal.to_s.uncolorize.should eq(message)
      end
    end
  end

  context "successes" do
    it "fetches tags successfully" do
      repository = Mint::Installer::Repository.new("name", "success")
      repository.versions.size.should eq(2)
    end

    it "clones successfully" do
      FileUtils.rm_rf("#{tmp_dir}/success")

      repository = Mint::Installer::Repository.open("name", "success")
      repository.output.should eq("  ✔ Cloned name (success)")
    end

    it "updates successfully" do
      FileUtils.mkdir_p("#{tmp_dir}/success")

      repository = Mint::Installer::Repository.open("name", "success")
      repository.output.should eq("  ✔ Updated name (success)")
    end
  end
end
