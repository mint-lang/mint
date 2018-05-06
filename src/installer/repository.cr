module Mint
  class Installer
    install_error RepositoryCouldNotGetVersions
    install_error RepositoryCouldNotCheckout
    install_error RepositoryInvalidMintJson
    install_error RepositoryCouldNotUpdate
    install_error RepositoryCouldNotClone
    install_error RepositoryNoMintJson

    class Repository
      getter name, url, target, version

      @version : Semver | Nil
      @target : String | Nil

      def initialize(@name = "", @url = "", @target = nil, @version = nil)
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

      def versions
        if version
          [version.not_nil!]
        else
          status, output, error = run "git tag --list"

          if status.success?
            output
              .strip
              .split
              .map { |version| Semver.parse(version) }
              .compact
              .sort_by(&.to_s)
              .reverse
          else
            raise RepositoryCouldNotGetVersions, {
              "result"  => error,
              "package" => id,
            }
          end
        end
      end

      def version(tag)
        json(tag).version
      end

      def dependencies(tag)
        json(tag).dependencies
      end

      def json(version : Semver)
        json(version.to_s)
      end

      def json(tag)
        target =
          self.target || tag

        checkout target

        MintJson.new(File.read(File.join(directory, "mint.json")), directory)
      rescue error : MintJson::Error
        raise RepositoryInvalidMintJson, {
          "target" => target.to_s,
          "url"    => url,
        }
      rescue error
        raise RepositoryNoMintJson, {
          "target" => target.to_s,
          "error"  => error.to_s,
          "url"    => url,
        }
      end

      def exists?
        Dir.exists?(directory)
      end

      def update
        status, output, error = run "git fetch --tags --force"

        if status.success?
          terminal.print "  #{CHECKMARK} Updated #{id}\n"
        else
          raise RepositoryCouldNotUpdate, {
            "result" => error,
            "url"    => url,
          }
        end
      end

      def clone
        status, output, error = run "git clone #{url} #{directory}", Dir.current

        if status.success?
          terminal.print "  #{CHECKMARK} Cloned #{id}\n"
        else
          raise RepositoryCouldNotClone, {
            "result" => error,
            "url"    => url,
          }
        end
      end

      def checkout(tag)
        target =
          self.target || tag

        status, output, error =
          run "git checkout #{target}"

        raise RepositoryCouldNotCheckout, {
          "target" => target.to_s,
          "url"    => url,
        }
      end

      def directory
        File.join(Tempfile.dirname, "mint-packages", url)
      end

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
