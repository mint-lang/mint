require "spec"
require "myhtml"

ERROR_MESSAGES = [] of String

class TypeError < Exception
  macro inherited
    ERROR_MESSAGES << {{@type.name.stringify.split("::").last.underscore}}
  end
end

class SyntaxError < Exception
  macro inherited
    ERROR_MESSAGES << {{@type.name.stringify.split("::").last.underscore}}
  end
end

require "../src/all"

macro subject(method)
  subject = ->(sample : String) {
    Parser.new(sample, "TestFile.mint").{{method}}
  }
end

macro expect_ok(sample)
  it "Parses: " + {{"#{sample}"}} do
    result = subject.call({{sample}})
    result.should_not be_nil
    result.should be_a(Ast::Node)
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
