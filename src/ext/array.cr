class Array(T)
  def &+(other : Enumerable | Array) : self
    concat(other)
  end

  def &+(other : Nil) : self
    self
  end

  def zip2(other : Array(T))
    map_with_index do |item, index|
      [item, other[index]?].compact
    end.flatten
  end

  def intersperse(separator : T)
    flat_map { |item| [item, separator] }.tap(&.pop?)
  end
end
