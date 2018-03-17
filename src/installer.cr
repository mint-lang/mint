require "./mint_json"
require "./installer/**"
require "file_utils"

alias Package = NamedTuple(name: String, version: String)
alias Constraint = FixedConstraint | SimpleConstraint

class Installer
  class Retry < Exception
  end

  class Failed < Exception
    getter name, package, constraint

    def initialize(@name : String, @package : Package, @constraint : Constraint)
    end
  end

  @dependencies =
    {} of Package => Hash(String, Constraint)

  @eliminated =
    [] of Tuple(Package, Package, Constraint)

  @repositories =
    {} of String => Repository

  @root_dependencies =
    [] of Dependency

  @resolved =
    {} of String => Semver

  @root =
    {name: "root", version: "0.0.0"}

  getter root, root_dependencies

  def initialize
    @root_dependencies = MintJson.parse_current.dependencies

    puts "Constructing dependency tree..."
    resolve_dependencies

    puts "\nResolving dependency tree..."
    solve
    print_resolved

    puts "\nCopying packages..."
    populate
  rescue error : Repository::Exception
    print_error do
      print_repository_error error
    end
  rescue error : Failed
    print_error do
      print_eliminated error
    end
  end

  def print_error
    puts "\n❗❗ COULD NOT INSTALL PACKAGES ❗❗".colorize(:red).mode(:bold)
    puts Terminal.separator.colorize(:light_red)
    yield
    raise CliException.new
  end

  def print_repository_error(error)
    puts "\nThere was an error when trying to interact with a repository:".colorize(:light_red)
    puts error.to_s.indent.colorize(:light_red)
    puts "\n"
  end

  def print_eliminated(error)
    puts "\nFailed to satisfy the following constraint:"
    puts "  #{error.name} #{error.constraint} from #{error.package}"

    if @eliminated.any?(&.[0][:name].==(error.name))
      puts "\nAll versions of #{error.name} were eliminated:"

      @eliminated.each do |item|
        next if item[0][:name] != error.name

        puts "  #{item[0][:version]} by #{item[2]} from #{item[1][:name]}:#{item[1][:version]} "
      end
    else
      puts "\nThere are no version available for #{error.name}"
    end
  end

  def print_resolved
    @resolved.each do |name, version|
      name =
        name
          .colorize(:light_green)
          .mode(:bold)

      version =
        version
          .colorize
          .mode(:bold)

      puts "  #{Terminal.diamond} #{name} #{Terminal.arrow} #{version}"
    end
  end

  # Populates the resolved package into "mint-stuff/packages" directory
  def populate
    @resolved.each do |name, version|
      # Determine resolved packages path
      destination =
        File.join(Dir.current, "mint-stuff", "packages", name)

      # Checkout the version we want
      @repositories[name].checkout(version)

      # Remove destination folder
      FileUtils.rm_rf(destination)

      # Create destination folder
      FileUtils.mkdir_p(File.dirname(destination))

      # Copy contents
      FileUtils.cp_r(@repositories[name].directory, destination)
    end
  end

  # Solves the dependency graph
  def solve(base = root)
    return unless @dependencies[base]?

    @dependencies[base].each do |dependency, constraint|
      repository =
        @repositories[dependency]

      resolved =
        @resolved[dependency]?

      upper =
        constraint.upper

      lower =
        constraint.lower

      # If it's already resolved
      if resolved
        # And matches the constraint
        if resolved < upper && resolved >= lower
          next
        else
          package =
            {name: dependency, version: resolved.to_s}

          # If it did not match eliminate and retry
          @eliminated << {package, base, constraint}
          raise Retry.new
        end
      else
        # Go through all versions
        repository.versions.each do |version|
          package = {name: dependency, version: version.to_s}

          # Skip if eliminated
          next if @eliminated.map(&.[0]).includes?(package)

          # Match constraint
          if version < upper && version >= lower
            # Set resolved and try to resolve the package
            @resolved[dependency] = version
            solve(package)
            break
          else
            # If it did not match eliminate and retry
            @eliminated << {package, base, constraint}
            raise Retry.new
          end
        end
      end

      # If every version was eliminated there no possible solution
      unless @resolved[dependency]?
        raise Failed.new(dependency, base, constraint)
      end
    end
  rescue error : Retry
    @resolved = {} of String => Semver
    solve
  end

  def resolve_dependencies(dependencies = root_dependencies, package = root)
    dependencies.each do |dependency|
      resolve_dependency(dependency, package)
    end
  end

  def resolve_dependency(dependency, package)
    # Don't resolved this dependency multiple times
    return if @dependencies[package]? &&
              @dependencies[package][dependency.name]?

    @dependencies[package] ||= {} of String => Constraint
    @dependencies[package][dependency.name] = dependency.constraint

    # Don't resolve versions of the dependency multiple times
    if @repositories[dependency.name]?
      # TODO: Check and warn here if we are using different repository than
      #       the resolved one.
      return
    else
      constraint =
        dependency.constraint

      root_dependency =
        root_dependencies.find(&.name.==(dependency.name))

      repository =
        @repositories[dependency.name] ||=
          if root_dependency &&
             root_dependency.constraint.is_a?(FixedConstraint)
            Repository.new(
              version: root_dependency.constraint.as(FixedConstraint).version,
              target: root_dependency.constraint.as(FixedConstraint).target,
              url: root_dependency.repository,
              name: root_dependency.name)
          else
            Repository.new(dependency.name, dependency.repository)
          end

      repository.versions.each do |version|
        json = repository.json(version)

        resolve_dependencies(
          json.dependencies,
          {name: dependency.name, version: version.to_s})
      end
    end
  end
end
