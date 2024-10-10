module Mint
  # A class for detecting changes to a set of sepcific files (sepcifically
  # `*.mint`, `.env` and `mint.json`).
  class Watcher
    @patterns : Array(String) = [] of String
    @state = Set(Tuple(String, Time)).new

    def initialize(&@listener : Proc(Array(String), Symbol, Nil))
    end

    def patterns=(@patterns : Array(String))
      @state.clear
      scan :reset
    end

    def scan(reason : Symbol)
      # We sort so the files can be processed in the same order every time.
      current =
        Dir.glob(@patterns)
          .map(&->info(String))
          .sort_by!(&.last)
          .to_set

      # Symmetric Difference: returns a new set (self - other) | (other - self).
      diff = @state ^ current

      # Only notify if there is actual changes.
      @listener.call(diff.map(&.first).uniq!, reason) unless diff.empty?

      @state = current
    end

    def info(file : String)
      path =
        Path[file].normalize.expand.to_s

      {path, File.info(path).modification_time}
    end

    def watch
      spawn do
        loop do
          sleep 0.5.seconds
          scan :modified
        end
      end
    end
  end
end
