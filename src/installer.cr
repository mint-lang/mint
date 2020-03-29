module Mint
  class Installer
    install_error InstallerFailedToInstall

    alias Package = NamedTuple(name: String, version: String)
    alias Constraint = FixedConstraint | SimpleConstraint

    class Retry < Exception; end

    @dependencies =
      {} of Package => Hash(String, Constraint)

    # This holds the elimiated packages, which package elminiated it
    # and with which constraint
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

      if @root_dependencies.empty?
        terminal.puts "There are no dependencies!\n\nThere is nothing to do!"
      else
        terminal.puts "#{COG} Constructing dependency tree..."
        resolve_dependencies

        terminal.puts "\n#{COG} Resolving dependency tree..."
        solve
        print_resolved

        terminal.puts "\n#{COG} Copying packages..."
        populate
      end
    end

    # Prints the resolved packages and their verions
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

        terminal.puts "  #{DIAMOND} #{name} #{ARROW} #{version}"
      end
    end

    # Populates the resolved package into ".mint/packages" directory
    def populate
      @resolved.each do |name, version|
        # Determine resolved packages path
        destination =
          File.join(Dir.current, ".mint", "packages", name)

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

      # We itarate over the dependencies of the given package (base)
      @dependencies[base].each do |dependency, constraint|
        # Clone or update the repository and save it
        repository =
          @repositories[dependency]

        # Check if this was resolved already
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
            # We are skipping
            next
          else
            package =
              {name: dependency, version: resolved.to_s}

            # If it did not match, eliminate and retry
            @eliminated << {package, base, constraint}
            raise Retry.new
          end
        else
          # If it's not resolved yet, we go through all versions
          repository.versions.each do |version|
            package = {name: dependency, version: version.to_s}

            # Skip if eliminated
            next if @eliminated.map(&.[0]).includes?(package)

            # If matches the constraint constraint
            if version < upper && version >= lower
              # Set this version as resolve and try to resolve the
              # packages dependencies
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
          eliminated =
            @eliminated
              .select { |item| item[0][:name] == dependency }
              .map { |item| "#{item[0][:version]} by #{item[2]} from #{item[1][:name]}:#{item[1][:version]}" }

          raise InstallerFailedToInstall, {
            "package"    => "#{base[:name]}:#{base[:version]}",
            "constraint" => constraint.to_s,
            "eliminated" => eliminated,
            "name"       => dependency,
          }
        end
      end
    rescue error : Retry
      # Clear the resolved cache
      @resolved = {} of String => Semver

      # Try to solve it again
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
        root_dependency =
          root_dependencies.find(&.name.==(dependency.name))

        repository =
          @repositories[dependency.name] ||=
            if root_dependency &&
               root_dependency.constraint.is_a?(FixedConstraint)
              # This is where fixed constraints happen, instead of simple
              # repository, we create a fixed repository.
              Repository.open(
                version: root_dependency.constraint.as(FixedConstraint).version,
                target: root_dependency.constraint.as(FixedConstraint).target,
                url: root_dependency.repository,
                name: root_dependency.name)
            else
              Repository.open(dependency.name, dependency.repository)
            end

        # Go through all of the dependencies and resolve them
        repository.versions.each do |version|
          json = repository.json(version)

          resolve_dependencies(
            json.dependencies,
            {name: dependency.name, version: version.to_s})
        end
      end
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
