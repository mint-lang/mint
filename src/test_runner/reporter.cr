module Mint
  class TestRunner
    abstract class Reporter
      abstract def succeeded(name)
      abstract def failed(name, error)
      abstract def errored(name, error)
      abstract def suite(name)
      abstract def done
      abstract def crashed(message)
    end
  end
end
