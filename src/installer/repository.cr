module Mint
  class Installer
    install_error RepositoryCouldNotGetVersions
    install_error RepositoryCouldNotCheckout
    install_error RepositoryInvalidMintJson
    install_error RepositoryCouldNotUpdate
    install_error RepositoryCouldNotClone
    install_error RepositoryNoMintJson

    # This class is for handling git repositories of packages.
    #
    # Repositories are cloned into a temp directory (/tmp/mint-packages) if
    # not exists and updated when they exsits.
    class Repository
      getter name : String
      getter url : String
      getter version : Semver?
      getter target : String?

      def self.open(name = "", url = "", target = nil, version = nil)
        if url.starts_with?("http://") && !url.ends_with?(".git")
          url += ".git"
        end

        new(name, url, target, version).tap(&.open)
      end

      def initialize(@name = "", @url = "", @target = nil, @version = nil)
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

        "#{name}#{at}"
      end

      # Gets the versions of a package from it's tags
      def versions : Array(Semver)
        if version = @version
          return [version]
        end

        status, output, error = run "git tag --list"

        raise RepositoryCouldNotGetVersions, {
          "result" => error,
          "url"    => url,
        } unless status.success?

        output
          .split
          .compact_map { |v| Semver.parse(v) }
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
          File.join(directory, "mint.json")

        checkout target

        MintJson.new(File.read(path), directory, path)
      rescue error : JsonError
        raise RepositoryInvalidMintJson, {
          "id"     => id.uncolorize,
          "target" => target.to_s,
        }
      rescue error : Error
        # Propagate RepositoryCouldNotCheckout
        raise error
      rescue error
        raise RepositoryNoMintJson, {
          "id"     => id.uncolorize,
          "target" => target.to_s,
        }
      end

      # Returns true if the repository is cloned yet.
      def exists?
        Dir.exists?(directory)
      end

      # Updates the repository.
      def update
        status, _, error = run "git fetch --tags --force"

        raise RepositoryCouldNotUpdate, {
          "result" => error,
          "url"    => url,
        } unless status.success?

        terminal.puts "  #{CHECKMARK} Updated #{id}"
      end

      # Clones the repository.
      def clone
        status, _, error = run "git clone #{url} #{directory}", Dir.current

        raise RepositoryCouldNotClone, {
          "result" => error,
          "url"    => url,
        } unless status.success?

        terminal.puts "  #{CHECKMARK} Cloned #{id}"
      end

      # Checks out the given tag or version.
      def checkout(tag)
        target =
          self.target || tag

        status, _, error = run "git checkout #{target}"

        raise RepositoryCouldNotCheckout, {
          "target" => target.to_s,
          "result" => error,
          "url"    => url,
        } unless status.success?
      end

      # The directory of the repository
      def directory
        File.join(MINT_PACKAGES_DIR, url)
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
