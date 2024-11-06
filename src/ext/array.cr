class Array(T)
  def zip2(other : Array(T))
    map_with_index do |item, index|
      [item, other[index]?].compact
    end.flatten
  end

  def intersperse(separator : T)
    flat_map { |item| [item, separator] }.tap(&.pop?)
  end
end
