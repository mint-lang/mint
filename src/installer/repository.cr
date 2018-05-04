module Mint
  class Installer
    install_error CouldNotGetVersions
    install_error CouldNotCheckout
    install_error CouldNotUpdate
    install_error CouldNotClone

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
            raise CouldNotGetVersions, {
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
        terminate "Invalid mint.json for #{id} at #{target}:\n#{error.to_s.indent}"
      rescue error
        terminate "Could not get mint.json for #{id} at #{target}:\n#{error.to_s.indent}"
      end

      def exists?
        Dir.exists?(directory)
      end

      def update
        status, output, error = run "git fetch --tags --force"

        if status.success?
          terminal.print "  #{CHECKMARK} Updated #{id}\n"
        else
          raise CouldNotUpdate, {
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
          raise CouldNotClone, {
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

        raise CouldNotCheckout, {
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

      def terminate(message)
        raise Error.new({
          "message" => message,
        } of String => Error::Value)
      end

      def raise(error : InstallError.class, raw)
        locals = {} of String => Error::Value

        case raw
        when Hash
          raw.map { |key, value| locals[key] = value }
        end

        raise error.new(locals)
      end

      def terminal
        Render::Terminal::STDOUT
      end
    end
  end
end
