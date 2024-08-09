def expect_diff(a, b)
  a.should eq(b)
rescue error
  puts a
  puts b
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
  parts =
    template.split(/×+/)

  position =
    0

  replaced =
    if parts.size <= 1
      template
    else
      parts.reduce("") do |memo, item|
        if index = expected.index(item, position)
          value =
            expected[position, index - position]

          position =
            index + item.size

          memo + value.to_s + item
        else
          memo + item
        end
      end
    end

  expect_diff(replaced, expected)
end
