module Mint
  class ServiceWorker
    def self.generate
      new.to_s
    end

    ECR.def_to_s "#{__DIR__}/service_worker.ecr"

    def files
      Dir
        .glob("**/*")
        .reject! { |file| File.directory?(file) }
        .join(",\n") { |file| "'/#{file}'" }
    end

    def calculate_hash
      Dir
        .glob("**/*")
        .reject! { |file| File.directory?(file) }
        .reduce(OpenSSL::Digest.new("SHA256")) do |digest, file|
          digest.update File.read(file)
        end.final.hexstring
    end
  end
end
