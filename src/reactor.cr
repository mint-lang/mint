require "./mint_json"
require "./reactor/**"

class Reactor
  include Mint::Logger

  def self.start
    new
  end

  @pattern = [] of String

  def initialize
    @error = Assets.read("error.js").as(String)
    @sockets = [] of HTTP::WebSocket
    @cache = {} of String => Ast
    @pattern = SourceFiles.all

    watch_for_changes
    setup_kemal

    Kemal.run
  end

  def script
    result = ""

    elapsed = Time.measure do
      Dir.glob(@pattern).each do |file|
        if !@cache.has_key?(file)
          artifact = Ast.new

          log "Parsing #{file}: " do
            artifact = Parser.parse(file)
          end

          log "Formatting #{file}: " do
            formatted =
              Formatter.new(artifact).format

            if formatted != File.read(file)
              File.write(file, formatted)
            end
          end

          @cache[file] = artifact
        end
      end

      ast =
        @cache
          .values
          .reduce(Ast.new) { |memo, item| memo.merge item }

      type_checker =
        TypeChecker.new(ast)

      log "Type checking: " do
        type_checker.check
      end

      result = log "Compiling: " do
        Compiler.compile type_checker.artifacts, {beautify: false}
      end
    end

    puts "All => #{TimeFormat.auto(elapsed)}"

    result
  rescue exception : SyntaxError
    puts exception.class
    error_script(exception.to_html)
  rescue exception : MintJson::Error | TypeError
    error_script(exception.message)
  end

  def json
    MintJson.parse_current
  end

  def index
    IndexHtml.render(Environment::DEVELOPMENT)
  end

  def error_script(content)
    @error.gsub("{{content}}",
      content.to_s
             .gsub('\\', "\\\\")
             .gsub('`', "\\`")
             .gsub('$', "\\$"))
  end

  def setup_kemal
    get "/index.js" do
      script
    end

    get "/:name" do |env|
      env.response.headers["Cache-Control"] = "max-age=2592000"

      if File.exists?("./public/#{env.params.url["name"]}")
        File.read("./public/#{env.params.url["name"]}")
      else
        begin
          Assets.read(env.params.url["name"])
        rescue BakedFileSystem::NoSuchFileError
          match =
            env.params.url["name"].match(/icon-(\d+)x\d+\.png$/)

          if match
            env.response.content_type = "image/png"
            IconGenerator.convert(json.application.icon, match[1])
          else
            index
          end
        end
      end
    end

    error 404 do |env|
      halt env, response: index, status_code: 200
    end

    ws "/" do |socket|
      @sockets.push socket
      socket.on_close do |_|
        @sockets.delete(socket)
      end
    end
  end

  def notify
    @sockets.each do |socket|
      socket.send("reload")
    end
  end

  def watch_for_changes
    source_watcher =
      Watcher.new(@pattern)

    spawn do
      Watcher.watch(["mint.json"]) do |files|
        @pattern =
          SourceFiles.all

        @cache =
          {} of String => Ast

        source_watcher.pattern =
          @pattern

        notify
      end
    end

    spawn do
      source_watcher.watch do |files|
        files.each { |file| @cache.delete(file) }
        notify
      end
    end
  end
end
