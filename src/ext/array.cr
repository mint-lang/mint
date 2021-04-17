class Array
  def intersperse(item)
    zip([item] * size).flatten[0...-1]
  end
end
