# Top level methods to raise a Mint::Error with data
def raise(error : Mint::Error.class)
  raise error, {} of String => Mint::Error::Value
end

def raise(error : Mint::Error.class, raw : Hash(String, T)) forall T
  locals = {} of String => Mint::Error::Value

  raw.map do |key, value|
    if value
      locals[key] = value
    end
  end

  raise error.new(locals)
end
