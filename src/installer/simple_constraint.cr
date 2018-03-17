class SimpleConstraint
  getter upper, lower

  def initialize(@lower : Semver, @upper : Semver)
  end

  def to_s
    "#{@lower} <= v < #{@upper}".colorize.mode(:bold).to_s
  end

  def to_s(io)
    io << to_s
    io
  end

  def ==(other)
    to_s == other.to_s
  end
end
