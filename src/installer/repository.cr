require "colorize"
require "../ext/**"

class Repository
  class Exception < Exception
  end

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
        terminate "Could not get the versions of package: #{id}\n#{error.indent}"
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

    status, output, error =
      run "git show #{target}:mint.json"

    if status.success?
      MintJson.new(output)
    else
      terminate "Could not get mint.json for #{id} at #{target}:\n#{error.indent}"
    end
  rescue error : MintJson::Error
    terminate "Invalid mint.json for #{id} at #{target}:\n#{error.to_s.indent}"
  end

  def exists?
    Dir.exists?(directory)
  end

  def update
    status, output, error = run "git fetch"

    if status.success?
      puts "  #{Terminal.cog} Updated #{id}"
    else
      terminate "Could not update #{url}:\n#{error.indent}"
    end
  end

  def clone
    status, output, error = run "git clone #{url} #{directory}", Dir.current

    if status.success?
      puts "  #{Terminal.checkmark} Cloned #{id}"
    else
      terminate "Could not clone #{url}:\n#{error.indent}"
    end
  end

  def checkout(tag)
    target =
      self.target || tag

    status, output, error =
      run "git checkout #{target}"

    unless status.success?
      terminate "Could not checkout #{target}:\n#{error.indent}"
    end
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
    raise Exception.new(message)
  end
end
