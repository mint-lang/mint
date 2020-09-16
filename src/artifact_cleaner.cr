module Mint
  class ArtifactCleaner
    def self.clean(clean_global : Bool = false)
      artifacts = [".mint", "dist"]

      if clean_global
        self.safe_delete(MINT_PACKAGES_DIR)
      else
        artifacts.each do |artifact_path|
          self.safe_delete(artifact_path)
        end
      end
    end

    private def self.safe_delete(dir_path)
      if Dir.exists?(dir_path)
        self.terminal.puts "Deleting: #{dir_path}"
        FileUtils.rm_rf(dir_path)
      end
    end

    def self.terminal
      Render::Terminal::STDOUT
    end
  end
end
