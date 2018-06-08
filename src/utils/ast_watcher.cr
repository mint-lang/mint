module Mint
  class AstWatcher
    @file_proc : Proc(String, Ast, Nil) = ->(_file : String, _ast : Ast) { nil }
    @pattern_proc : Proc(Array(String)) = ->{ [] of String }
    @cache = {} of String => Ast
    @channel = Channel(Nil).new
    @pattern = [] of String

    def initialize
    end

    def initialize(@pattern_proc, @file_proc = ->(_file : String, _ast : Ast) { nil })
      @pattern = @pattern_proc.call

      watch_for_changes

      yield compile
    rescue exception : Error
      yield exception
    end

    def watch
      loop do
        @channel.receive
        yield compile
      end
    end

    def compile
      Dir.glob(@pattern).each do |file|
        @cache[file] ||= Parser.parse(file)
        @file_proc.call(file, @cache[file])
      end

      @cache
        .values
        .reduce(Ast.new) { |memo, item| memo.merge item }
    rescue exception : Error
      exception
    end

    # Sets up watchers to detect changes
    def watch_for_changes
      # The pattern of the source files can change when deleting a file
      # so we need to have an instance available.
      source_watcher =
        Watcher.new(@pattern)

      spawn do
        # When the mint.json changes
        Watcher.watch(["mint.json"]) do
          # We need to update the patterns because:
          # 1. packages could have been added or removed
          # 2. source directories could have been added or removed
          @pattern =
            SourceFiles.all

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
