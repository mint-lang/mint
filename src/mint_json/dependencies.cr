module Mint
  class MintJson
    def parse_dependencies
      @parser.location.try do |location|
        @parser.read_object do |key|
          @dependencies << parse_dependency(key)
        end

        error! :dependencies_empty do
          block do
            text "The"
            bold "dependencies"
            text "field lists all the dependencies for the application."
          end

          block do
            text "The"
            bold "dependencies"
            text "object should not be empty, but it is:"
          end

          snippet snippet_data(location)
        end if source_directories.empty?
      end
    rescue JSON::ParseException
      error! :dependencies_invalid do
        block do
          text "The"
          bold "dependencies"
          text "field lists all the dependencies for the application."
        end

        snippet "It should be an object, but it's not:", snippet_data
      end
    end

    def parse_dependency(package : String) : Installer::Dependency
      repository, constraint = nil, nil

      @parser.read_object do |key|
        case key
        when "repository"
          repository = parse_dependency_repository
        when "constraint"
          constraint = parse_dependency_constraint
        else
          error! :dependency_invalid_key do
            snippet "A dependency object has an invalid key:", key
            snippet "It is here:", snippet_data
          end
        end
      end

      error! :dependency_missing_repository do
        block do
          text "A"
          bold "dependency object"
          text "is missing the"
          bold "repository"
          text "field:"
        end

        snippet snippet_data
      end unless repository

      error! :dependency_missing_constraint do
        block do
          text "A"
          bold "dependency object"
          text "is missing the"
          bold "constraint"
          text "field:"
        end

        snippet snippet_data
      end unless constraint

      Installer::Dependency.new package, repository, constraint
    rescue JSON::ParseException
      error! :dependency_invalid do
        snippet "A dependency must be an object, but it's not:", snippet_data
      end
    end

    def parse_dependency_repository
      @parser.read_string
    rescue JSON::ParseException
      error! :dependency_repository_invalid do
        block do
          text "The"
          bold "repository"
          text "field of a depencency must be an string, but it's not:"
        end

        snippet snippet_data
      end
    end

    def parse_dependency_constraint
      location =
        @parser.location

      raw =
        @parser.read_string

      match =
        raw.match(/(\d+\.\d+\.\d+)\s*<=\s*v\s*<\s*(\d+\.\d+\.\d+)/)

      constraint =
        if match
          lower =
            Installer::Semver.parse?(match[1])

          upper =
            Installer::Semver.parse?(match[2])

          Installer::SimpleConstraint.new(lower, upper) if upper && lower
        else
          match =
            raw.match(/(.*?):(\d+\.\d+\.\d+)/)

          if match
            version =
              Installer::Semver.parse?(match[2])

            target =
              match[1]

            Installer::FixedConstraint.new(version, target) if version
          end
        end

      error! :dependency_constraint_bad do
        block "The constraint of a dependency is either in this format:"
        snippet "0.0.0 <= v < 1.0.0"

        block "or a git tag / commit / branch followed by the version:"
        snippet "master:0.1.0"

        snippet "I could not find either:", snippet_data(location)
      end unless constraint

      constraint
    rescue JSON::ParseException
      error! :dependency_constraint_invalid do
        block do
          text "The"
          bold "constraint"
          text "field of a depencency must be an string, but it's not:"
        end

        snippet snippet_data
      end
    end
  end
end
