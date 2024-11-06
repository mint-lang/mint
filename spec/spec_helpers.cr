def expect_diff(a, b)
  a.should eq(b)
rescue error
  fail diff(a, b)
end

def diff(a, b)
  file1 = File.tempfile do |file|
    file.puts a.strip
    file.flush
  end

  file2 = File.tempfile do |file|
    file.puts b
    file.flush
  end

  io = IO::Memory.new

  Process.run("git", [
    "--no-pager", "diff", "--no-index", "--color=always",
    file1.path, file2.path,
  ], output: io)

  io.to_s
ensure
  file1.try &.delete
  file2.try &.delete
end

def matches_template(template, expected)
  expected =
    expected.uncolorize

  parts =
    template.split(/×+/)

  fills =
    [] of String

  parts.reduce(0) do |position, item|
    unless index = expected.index(item, position)
      raise <<-TEXT
        TEMPLATE INVALID!

        TEMPLATE:
        #{template}

        ITEM:
        #{item}

        EXPECTED:
        #{expected}
        TEXT
    end

    fills << expected[position, index - position]
    index + item.size
  end

  replaced =
    parts.zip(fills).join { |part, fill| fill + part }

  expect_diff(replaced, expected)
end
