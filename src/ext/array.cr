class Array(T)
  def &+(other : Enumerable | Array) : self
    concat(other)
  end

  def &+(other : Nil) : self
    self
  end

  def intersperse(separator : T)
    flat_map { |item| [item, separator] }.tap(&.pop?)
  end
end
