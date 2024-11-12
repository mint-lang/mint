require "benchmark"
require "../src/all"

module Mint
  Benchmark.ips(warmup: 4.seconds, calculation: 10.seconds) do |x|
    x.report("Core parsing") do
      Core.files.reduce(Ast.new) do |memo, file|
        Parser.parse(file.read, file.path).try do |ast|
          memo.merge(ast)
        end
      end
    end
  end
end
