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
        artifacts.each do |artifact|
          Dir.safe_delete artifact do
            terminal.puts "Deleting: #{artifact}"
          end
        end
      else
        terminal.puts "Nothing to delete."
      end
    end

    def self.terminal
      Render::Terminal::STDOUT
    end
  end
end
