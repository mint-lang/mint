module Mint
  class ArtifactCleaner
    def self.clean(clean_packages : Bool = false)
      artifacts =
        if clean_packages
          [MINT_PACKAGES_DIR]
        else
          %w[.mint dist]
        end

      # ameba:disable Performance/AnyInsteadOfEmpty
      if artifacts.any?(&->Dir.exists?(String))
        artifacts.each(&->safe_delete(String))
      else
        terminal.puts "Nothing to delete."
      end
    end

    private def self.safe_delete(directory)
      return unless Dir.exists?(directory)

      terminal.puts "Deleting: #{directory}"
      FileUtils.rm_rf(directory)
    end

    def self.terminal
      Render::Terminal::STDOUT
    end
  end
end
