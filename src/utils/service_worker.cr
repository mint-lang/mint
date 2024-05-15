module Mint
  class ServiceWorker
    @relative : Bool
    @optimize : Bool
    @artifacts : TypeChecker::Artifacts

    def initialize(@artifacts, @relative, @optimize)
      @js =
        Js.new(optimize: @optimize)
    end

    protected def path_for(url)
      @relative ? url : "/#{url}"
    end

    ECR.def_to_s "#{__DIR__}/service_worker.ecr"

    getter files : Array(Path) do
      Dir
        .glob(Path[DIST_DIR, "**", "*"])
        .compact_map do |file|
          Path[file] unless File.directory?(file)
        end
        .sort!
    end

    def precache_urls
      files
        .join(",\n") do |file|
          %('#{path_for(file.relative_to(DIST_DIR))}')
        end
    end

    def calculate_hash
      files
        .reduce(OpenSSL::Digest.new("SHA256")) do |digest, file|
          digest.file(file)
        end.hexfinal
    end

    def build_routes : String
      routes = Mint::Compiler
        .new(TypeChecker.check(@artifacts.ast))
        .compile_service_worker(@artifacts.ast.routes)
        .map { |node| "...#{node}" }

      @js.const("routes", "[#{routes.join(", ")}]")
    end
  end
end
