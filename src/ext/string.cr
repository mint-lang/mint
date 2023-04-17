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

  def shrink_to_minimum_leading_whitespace : String
    # We start from the maximum number for indent size
    indent_size =
      Int32::MAX

    # Iterate over all the lines and:
    # - replace tabs with 2 spaces
    # - update the indent size if it's smaller than the previous
    lines =
      self
        .lines
        .map do |line|
          reader = Char::Reader.new(line)
          size = 0

          loop do
            case reader.current_char
            when '\t'
              size += 2
            when ' '
              size += 1
            else
              break
            end

            reader.next_char
          end

          # For the indent size we ignore blank lines
          if size < indent_size && !line.blank?
            indent_size = size
          end

          (" " * size) + line[reader.pos..]?.to_s
        end

    # Remove the least number of indentation and recreate the string.
    lines
      .map(&.[indent_size..]?.to_s)
      .join("\n")
  end
end
