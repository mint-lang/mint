module Mint
  class Watcher
    def self.watch(pattern, &)
      new(pattern).watch { |files| yield files }
    end

    setter pattern

    def initialize(@pattern : Array(String))
      @state = Set(Tuple(String, Time)).new
      detect { }
    end

    def detect(&)
      current = Set(Tuple(String, Time)).new

      Dir.glob(@pattern).each do |file|
        path =
          Path[file].normalize.to_s

        current.add({path, File.info(path).modification_time})
      end

      yield @state ^ current

      @state = current
    end

    def watch(&)
      loop do
        detect do |diff|
          yield diff.map(&.[0]).uniq! unless diff.empty?
        end

        sleep 0.5
      end
    end
  end
end
