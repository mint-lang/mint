class String
  def uncolorize : String
    self
      .gsub(/[ \t]+$/m, "")
      .gsub(/\e\[(\d+;?)*m/, "")
      .rstrip
  end

  def last? : Char?
    self[-1]?
  end

  def indent(spaces : Int32 = 2) : String
    lines.join('\n') do |line|
      line.empty? ? line : (" " * spaces) + line
    end
  end

  def remove_all_leading_whitespace : String
    lines.join('\n', &.lstrip(" \t"))
  end

  def remove_leading_whitespace : String
    # Count the leading whitespace in each line
    count =
      lines
        .compact_map { |line| line.presence.try(&.leading_whitespace_count) }
        .min? || 0

    # Remove the minimum count of lines
    lines
      .join('\n') { |line| line.lchop(line[0, count]) }
      .strip("\n\r")
  end

  def leading_whitespace_count : Int32
    i = 0
    while self[i]?.try(&.ascii_whitespace?)
      i += 1
    end
    i
  end

  def remove_trailing_whitespace : String
    lines.join('\n', &.rstrip)
  end
end
