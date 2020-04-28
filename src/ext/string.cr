class String
  def uncolorize : String
    gsub(/[ \t]+$/m, "")
      .gsub(/\e\[(\d+;?)*m/, "")
      .rstrip
  end

  def last? : Char?
    self[size - 1] unless empty?
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
        .reject!(&.blank?)
        .compact_map(&.leading_whitespace_count)
        .min? || 0

    # Remove the minimum count of lines
    lines
      .join('\n') { |line| line.lchop(line[0, count]) }
      .strip("\n\r")
  end

  def leading_whitespace_count : Int32
    return 0 if empty?
    i = 0
    while self[i].ascii_whitespace?
      i += 1
    end
    i
  end

  def remove_trailing_whitespace : String
    lines.join('\n', &.rstrip)
  end
end
