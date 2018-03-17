class Dependency
  getter repository, constraint, name

  def initialize(@name : String, @repository : String, @constraint : Constraint)
  end
end
