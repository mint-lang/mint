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
      getter name, url, target, version

      @version : Semver | Nil
      @target : String | Nil

      def self.open(name = "", url = "", target = nil, version = nil)
        if url.starts_with?("http") && !url.ends_with?(".git")
          url = "#{url}.git"
        end

        repository = new(name, url, target, version)
        repository.open
        repository
      end

      def initialize(@name = "", @url = "", @target = nil, @version = nil)
      end

      def open
        if exists?
          update
        else
          clone
        end
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
        if version
          [version.not_nil!]
        else
          status, output, error = run "git tag --list"

          if status.success?
            output
              .strip
              .split
              .compact_map { |version| Semver.parse(version) }
              .sort_by(&.to_s)
              .reverse
          else
            raise RepositoryCouldNotGetVersions, {
              "result" => error,
              "url"    => url,
            }
          end
        end
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
      rescue error
        # Propagate RepositoryCouldNotCheckout
        raise error if error.is_a?(Error)

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

        if status.success?
          terminal.puts "  #{CHECKMARK} Updated #{id}"
        else
          raise RepositoryCouldNotUpdate, {
            "result" => error,
            "url"    => url,
          }
        end
      end

      # Clones the repository.
      def clone
        status, _, error = run "git clone #{url} #{directory}", Dir.current

        if status.success?
          terminal.puts "  #{CHECKMARK} Cloned #{id}"
        else
          raise RepositoryCouldNotClone, {
            "result" => error,
            "url"    => url,
          }
        end
      end

      # Checks out the given tag or version.
      def checkout(tag)
        target =
          self.target || tag

        status, _, error =
          run "git checkout #{target}"

        raise RepositoryCouldNotCheckout, {
          "target" => target.to_s,
          "result" => error,
          "url"    => url,
        } unless status.success?
      end

      # The directory of the repository
      def directory
        File.join(Dir.tempdir, "mint-packages", url)
      end

      # Runs a git command and returns it's status, output and error in a tuple.
      def run(command, chdir = directory)
        output =
          IO::Memory.new

        error =
          IO::Memory.new

        status =
          Process.run(
            command,
            shell: true,
            chdir: chdir,
            error: error,
            output: output)

        {status, output.to_s, error.to_s}
      end

      def terminal
        Render::Terminal::STDOUT
      end
    end
  end
end
