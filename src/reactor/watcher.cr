class Watcher
  def self.watch(pattern)
    new(pattern).watch { |files| yield files }
  end

  setter pattern

  def initialize(@pattern : Array(String))
    @state = Set(Tuple(String, Time)).new
  end

  def watch
    loop do
      current = Set(Tuple(String, Time)).new

      Dir.glob(@pattern).each do |file|
        current.add({file, File.stat(file).mtime})
      end

      diff = @state ^ current

      yield diff.map(&.[0]).uniq if diff.any?

      @state = current

      sleep 0.5
    end
  end
end
