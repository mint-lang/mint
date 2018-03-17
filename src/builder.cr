require "time_format"
require "tree_template"
require "./builder/**"

enum Environment
  DEVELOPMENT
  BUILD
end

GLOBAL_STYLES =
  "body {
  overflow-y: scroll;
  margin: 0;
}

* {
  box-sizing: border-box;
}"

module IconGenerator
  extend self

  def convert(image, size)
    output =
      IO::Memory.new

    error =
      IO::Memory.new

    status =
      Process.run(
        "convert #{image} -resize #{size}x#{size} -",
        shell: true, error: error, output: output)

    if status.success?
      output.to_s
    else
      ""
    end
  end
end

class Builder
  include Mint::Logger

  SIZES = [16, 32, 57, 76, 96, 120, 128, 144, 152, 167, 180, 196, 256]

  def initialize
    json = MintJson.parse_current

    log "#{Terminal.cog} Clearing the \"dist\" directory... " do
      FileUtils.rm_rf "dist"
      FileUtils.mkdir "dist"
    end

    log "#{Terminal.cog} Copying public folder contents... " do
      FileUtils.cp Dir.glob("public/**/*"), "dist"
    end

    puts "#{Terminal.cog} Compiling your appliction: "
    File.write "dist/index.js", index

    log "#{Terminal.cog} Writing index.html... " do
      File.write "dist/index.html", IndexHtml.render(Environment::BUILD)
    end

    log "#{Terminal.cog} Generating icons... " do
      icons(json)
    end
  end

  def icons(json)
    SIZES.each do |size|
      destination =
        File.join("dist", "icon-#{size}x#{size}.png")

      icon =
        IconGenerator.convert(json.application.icon, size)

      File.write(destination, icon)
    end
  end

  def index
    runtime =
      Assets.read("runtime.js")

    sources = Dir.glob(SourceFiles.all)
    ast = Ast.new
    compiled = ""

    log "  #{Terminal.arrow} Parsing #{sources.size} source files... " do
      sources.reduce(ast) do |memo, file|
        memo.merge Parser.parse(file)
        memo
      end
    end

    type_checker =
      TypeChecker.new(ast)

    log "  #{Terminal.arrow} Type checking: " do
      type_checker.check
    end

    log "  #{Terminal.arrow} Compiling: " do
      compiled = Compiler.compile type_checker.artifacts, {beautify: false}
    end

    runtime + compiled
  end
end
