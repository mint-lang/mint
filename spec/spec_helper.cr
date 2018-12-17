require "spec"
require "diff"

MINT_ENV["TEST"] = "YES"
ERROR_MESSAGES = [] of String

class Mint::Error < Exception
  macro inherited
    name = {{@type.name.stringify.split("::").last.underscore}}

    unless ["type_error", "install_error", "syntax_error", "json_error"].includes?(name)
      ERROR_MESSAGES << name
    end
  end
end

require "../src/all"

# Mock things
class Mint::Installer::Repository
  @terminal = Render::Terminal.new

  def terminal
    @terminal
  end

  def output
    terminal.io.to_s.uncolorize
  end

  def run(command, chdir = directory)
    content =
      case command.split(" ")[1]
      when "tag"
        "0.1.0\n0.2.0"
      when "fetch"
        "fetched"
      when "checkout"
        "checked out"
      when "clone"
        "cloned"
      else
        ""
      end

    if url == "error"
      {Process::Status.new(1), "", content}
    else
      {Process::Status.new(0), content, ""}
    end
  end
end

macro subject(method)
  subject = ->(sample : String) {
    Mint::Parser.new(sample, "TestFile.mint").{{method}}
  }
end

macro expect_ok(sample)
  it "Parses: " + {{"#{sample}"}} do
    result = subject.call({{sample}})
    result.should_not be_nil
    result.should be_a(Mint::Ast::Node)
  end
end

macro expect_ignore(sample)
  it {{"#{sample}"}} do
    subject.call({{sample}}).should be_nil
  end
end

macro expect_error(sample, error)
  it {{"#{sample}"}} do
    expect_raises({{error}}) do
      subject.call({{sample}})
    end
  end
end
