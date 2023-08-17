module Mint
  # A workspace represents a mint project where the root is the directory
  # containing the `mint.json` file.
  #
  # The workspace provides:
  # - an up to date AST of the project
  # - provides packages and information
  # - emits events for changes
  class Workspace
    @@workspaces = {} of String => Workspace

    class_getter workspaces

    def self.from_file(path : String) : Workspace
      new(root_from_file(path))
    end

    def self.current : Workspace
      new(Dir.current)
    end

    def self.root_from_file(path : String) : String
      root = File.dirname(path)

      loop do
        raise "Invalid workspace!" if root == "." || root == "/"

        if File.exists?(Path[root, "mint.json"])
          break
        else
          root = File.dirname(root)
        end
      end

      root
    end

    def self.[](path)
      root = root_from_file(path)

      @@workspaces[root] ||=
        Workspace.new(root)
          .tap(&.update_cache)
          .tap(&.watch)
    end

    alias ChangeProc = Proc(Ast | Error2, Nil)

    @event_handlers = {} of String => Array(ChangeProc)
    @cache = {} of String => Ast
    @pattern = %w[]

    getter type_checker : TypeChecker
    getter cache : Hash(String, Ast)
    getter formatter : Formatter
    getter json : MintJson
    getter error : Error2?
    getter root : String

    property? format : Bool = false

    def initialize(@root : String)
      json_path =
        Path[@root, "mint.json"].to_s

      @json =
        FileUtils.cd(@root) do
          MintJson.from_file(json_path)
        end

      @formatter =
        Mint::Formatter.new(json.formatter_config)

      @json_watcher =
        Watcher.new([json_path])

      @source_watcher =
        Watcher.new(all_files_pattern)

      @static_watcher =
        Watcher.new(all_static_pattern)

      @type_checker =
        TypeChecker.new(Ast.new)
    end

    def on(event, &handler : ChangeProc)
      @event_handlers[event] ||= [] of ChangeProc
      @event_handlers[event] << handler
    end

    def packages : Array(Workspace)
      pattern =
        Path[root, ".mint", "packages", "**", "mint.json"]

      Dir.glob(pattern).map do |file|
        Workspace.from_file(file)
      end
    end

    def ast
      result =
        @cache.values.reduce(Ast.new) { |memo, item| memo.merge item }

      result.merge(Core.ast) if @json.name != "core"
      result.normalize
    end

    def []?(file)
      @cache[normalize_path(file)]?
    end

    def [](file)
      @cache[normalize_path(file)]
    end

    protected def []=(file, value)
      @cache[normalize_path(file)] = value
    end

    def initialize_cache(&)
      files = self.files
      files.each_with_index do |file, index|
        self[file] ||= Parser.parse(file)

        yield file, index, files.size
      end
    end

    def watch
      spawn do
        # Watches static files
        @static_watcher.watch do
          call "change", ast
        end
      end

      spawn do
        # Watches all the `*.mint` files
        @source_watcher.watch do |files|
          # Remove the changed files from the cache
          files.each { |file| @cache.delete(file) }

          # Update the cache
          update_cache
        end
      end

      spawn do
        # Watches the `mint.json` file
        @json_watcher.watch do
          # We need to update the patterns because:
          # 1. packages could have been added or removed
          # 2. source directories could have been added or removed
          update_patterns

          # Reset the cache, this will cause a full recompilation, in the
          # future this could be changed to only remove files from the cache
          # that have been changed.
          reset_cache
        end
      end
    end

    def files
      Dir.glob(all_files_pattern)
    end

    def files_pattern : Array(String)
      json
        .source_directories
        .map { |dir| Path[root, dir, "**", "*.mint"].to_posix.to_s }
    end

    def static_pattern : Array(String)
      json
        .external_files
        .values
        .flatten
    end

    def update_cache
      files.each do |file|
        path =
          File.realpath(file)

        self[file] ||= process(File.read(path), path)
      end

      check!

      @error = nil

      call "change", ast
    rescue error : Error2
      @error = error

      call "change", error
    end

    def format(file)
      Formatter
        .new(json.formatter_config)
        .format(self[file])
    end

    def update(contents, file)
      self[file] = process(contents, file)
      check!
      @error = nil

      call "change", ast
    rescue error : Error2
      @error = error

      call "change", error
    end

    private def normalize_path(file)
      Path[file].normalize.to_s
    end

    private def process(contents, file)
      ast =
        Parser.parse(contents, File.realpath(file))

      if format?
        formatted =
          Formatter
            .new(json.formatter_config)
            .format(ast)

        if formatted != File.read(file)
          File.write(file, formatted)
        end
      end

      ast
    end

    private def check!
      @type_checker = Mint::TypeChecker.new(ast, check_env: false)
      @type_checker.check
    end

    private def call(event, arg)
      @event_handlers[event]?.try(&.each(&.call(arg)))
    end

    private def reset_cache
      @cache = {} of String => Ast
      update_cache
    end

    private def update_patterns
      @static_watcher.pattern = all_static_pattern
      @source_watcher.pattern = all_files_pattern
    end

    private def all_static_pattern : Array(String)
      packages
        .flat_map(&.static_pattern)
        .concat(static_pattern)
    end

    private def all_files_pattern : Array(String)
      packages
        .flat_map(&.files_pattern)
        .concat(files_pattern)
    end
  end
end
