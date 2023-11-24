module Mint
  class AstWatcher
    @file_proc : Proc(String, Ast, Nil) = ->(_file : String, _ast : Ast) {}
    @pattern_proc : Proc(Array(String)) = ->{ %w[] }
    @cache = {} of String => Ast
    @channel = Channel(Nil).new
    @pattern = %w[]
    @progress = false
    @include_core = true

    def initialize
    end

    def initialize(@pattern_proc, @file_proc = ->(_file : String, _ast : Ast) {}, @progress = false, @include_core = true, &)
      @pattern = @pattern_proc.call

      watch_for_changes

      yield compile(progress)
    rescue error : Error
      yield error
    end

    def watch(&)
      loop do
        @channel.receive
        yield compile
      end
    end

    def terminal
      Render::Terminal::STDOUT
    end

    def compile(print = false)
      files =
        Dir.glob(@pattern)

      prefix = "#{COG} Parsing files"
      line = ""

      elapsed = Time.measure do
        files.each_with_index do |file, index|
          if print
            file_counter = "#{index} / #{files.size}".colorize.mode(:bold)
            line = "#{prefix}: #{file_counter}".ljust(line.size)
            terminal.io.print("#{line}\r")
            terminal.io.flush
          end

          @cache[file] ||= Parser.parse(file)
          @file_proc.call(file, @cache[file])
        end
      end

      if print
        elapsed = TimeFormat.auto(elapsed).colorize.mode(:bold)
        terminal.io.puts "#{prefix}... #{elapsed}".ljust(line.size)
      end

      @progress = false

      ast =
        @cache
          .values
          .reduce(Ast.new) { |memo, item| memo.merge item }

      ast.merge(Core.ast) if @include_core
      ast
    rescue error : Error
      error
    end

    # Sets up watchers to detect changes
    def watch_for_changes
      # The pattern of the source files can change when deleting a file
      # so we need to have an instance available.
      source_watcher =
        Watcher.new(@pattern)

      spawn do
        # When the mint.json changes
        Watcher.watch(%w[mint.json]) do
          # We need to update the patterns because:
          # 1. packages could have been added or removed
          # 2. source directories could have been added or removed
          @pattern =
            @pattern_proc.call

          # Reset the cache, this will cause a full recompilation, in the
          # future this could be changed to only remove files from the cache
          # that have been changed.
          @cache =
            {} of String => Ast

          # Update the pattern on the watcher.
          source_watcher.pattern =
            @pattern

          @channel.send(nil)
        end
      end

      spawn do
        # When a source files change
        source_watcher.watch do |files|
          # Remove them from the cache.
          files.each { |file| @cache.delete(file) }

          @channel.send(nil)
        end
      end
    end
  end
end
