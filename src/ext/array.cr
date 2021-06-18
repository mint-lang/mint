class Array(T)
  def &+(other : Enumerable | Array) : self
    concat(other)
  end

  def &+(other : Nil) : self
    self
  end
end
