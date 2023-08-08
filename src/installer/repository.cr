module Mint
  class Installer
    # This class is for handling git repositories of packages.
    #
    # Repositories are cloned into a temp directory (/tmp/mint-packages) if
    # not exists and updated when they exists.
    class Repository
      include Errorable

      getter name : String
      getter url : String
      getter version : Semver?
      getter target : String?

      def self.open(name, url, target = nil, version = nil)
        if url.starts_with?(%r{https?://}) && !url.ends_with?(".git")
          url += ".git"
        end

        new(name, url, target, version).tap(&.open)
      end

      def initialize(@name, @url, @target = nil, @version = nil)
      end

      def open
        exists? ? update : clone
      end

      def id
        name =
          self
            .name
            .colorize
            .mode(:bold)

        at =
          "(#{url})"
            .colorize(:light_blue)
            .mode(:dim)

        "#{name} #{at}"
      end

      # Gets the versions of a package from its tags
      def versions : Array(Semver)
        if version = @version
          return [version]
        end

        status, output, error = run "git tag --list"

        error! :repository_could_not_get_versions do
          block do
            text "I could not get the tags of the repository:"
            bold url
          end

          block "The error I got from the git command is this:"

          block do
            bold error.to_s.strip
          end
        end unless status.success?

        output
          .split
          .compact_map { |v| Semver.parse?(v) }
          .sort_by!(&.to_s)
          .reverse!
      end

      # Returns the dependencies of the tag or version.
      def dependencies(tag)
        json(tag).dependencies
      end

      # Returns the mint.json of the given version.
      def json(version : Semver)
        json(version.to_s)
      end

      # Returns the mint.json of the given tag or version.
      def json(tag)
        target =
          self.target || tag

        path =
          Path[directory, "mint.json"].to_s

        checkout target

        MintJson.new(File.read(path), directory, path)
      rescue error : Error
        if error.name.to_s.starts_with?("mint_json")
          error! :repository_invalid_mint_json do
            block do
              text "I could not parse the mint.json for the package:"
              bold id.uncolorize
              text "for the version or tag:"
              bold target.to_s
            end
          end
        else
          # Propagate RepositoryCouldNotCheckout
          raise error
        end
      rescue error
        error! :repository_no_mint_json do
          block do
            text "I could not find the mint.json for the package:"
            bold id.uncolorize
            text "for the version or tag:"
            bold target.to_s
          end
        end
      end

      # Returns true if the repository is cloned yet.
      def exists?
        Dir.exists?(directory)
      end

      # Updates the repository.
      def update
        status, _, error = run "git fetch --tags --force"

        error! :repository_could_not_update do
          block do
            text "I could not update the repository:"
            bold url
          end

          block "The error I got from the git command is this:"

          block do
            bold error.to_s.strip
          end
        end unless status.success?

        terminal.puts "  #{CHECKMARK} Updated #{id}"
      end

      # Clones the repository.
      def clone
        status, _, error = run "git clone #{url} #{directory}", Dir.current

        error! :repository_could_not_clone do
          block do
            text "I could not clone the repository:"
            bold url
          end

          block "The error I got from the git command is this:"

          block do
            bold error.to_s.strip
          end
        end unless status.success?

        terminal.puts "  #{CHECKMARK} Cloned #{id}"
      end

      # Checks out the given tag or version.
      def checkout(tag)
        target =
          self.target || tag

        status, _, error = run "git checkout #{target} -f"

        error! :repository_could_not_checkout do
          block do
            text "I could not checkout the version or tag:"
            bold target.to_s
            text "of the repository:"
            bold url
          end

          block "The error I got from the git command is this:"

          block do
            bold error.to_s.strip
          end
        end unless status.success?
      end

      # The directory of the repository
      def directory
        Path[MINT_PACKAGES_DIR, url].to_s
      end

      # Runs a shell command and returns its status, output and error in a tuple.
      private def run(command, chdir = directory)
        output = IO::Memory.new
        error = IO::Memory.new

        status =
          Process.run(
            command,
            shell: true,
            chdir: chdir,
            error: error,
            output: output)

        {status, output.to_s.strip, error.to_s.strip}
      end

      def terminal
        Render::Terminal::STDOUT
      end
    end
  end
end
