module Mint
  class Installer
    include Errorable

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

    @resolved =
      {} of String => Semver

    getter root = {name: "root", version: "0.0.0"}
    getter root_dependencies = [] of Dependency

    def initialize
      @root_dependencies = MintJson.parse_current.dependencies

      if @root_dependencies.empty?
        terminal.puts "There are no dependencies!\n\nThere is nothing to do!"
      else
        terminal.puts "#{COG} Constructing dependency tree..."
        resolve_dependencies

        terminal.puts
        terminal.puts "#{COG} Resolving dependency tree..."
        solve
        print_resolved

        terminal.puts
        terminal.puts "#{COG} Copying packages..."
        populate
      end
    end

    # Prints the resolved packages and their versions
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
          Path[Dir.current, ".mint", "packages", name].to_s

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

            begin
              repository.json(version)
            rescue error : Error2
              # If the mint.json is invalid or missing then this version
              # is eliminated.
              @eliminated << {package, base, constraint}
            end

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
              .select(&.[0][:name].==(dependency))
              .map do |item|
                "#{item[0][:version]} by #{item[2]} from #{item[1][:name]}:#{item[1][:version]}"
              end

          error :installer_failed_to_install do
            block "Failed to satisfy the following constraint:"

            block do
              bold "#{dependency} #{constraint}"
              text "from"
              bold "#{base[:name]}:#{base[:version]}"
            end

            case eliminated
            when Array(String)
              unless eliminated.empty?
                block do
                  text "All versions of"
                  bold name.to_s
                  text "were eliminated:"
                end

                snippet eliminated.join("\n")

                block do
                  text "There are no version available for:"
                  bold name.to_s
                end
              end
            end
          end
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
        rescue Error2
          # Since we don't have a valid json we don't resolve the dependencies
        end
      end
    end

    def terminal
      Render::Terminal::STDOUT
    end
  end
end
