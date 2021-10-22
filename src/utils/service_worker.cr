module Mint
  class ServiceWorker
    @relative : Bool

    def self.generate(relative = false)
      new(relative).to_s
    end

    def initialize(@relative)
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
        end.final.hexstring
    end
  end
end
