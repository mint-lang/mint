require "./spec_helper"

Dir.glob("./spec/type_checking/**").each do |file|
  # Read samples
  samples = [] of Tuple(String, String | Nil)
  contents = File.read(file)
  name = File.basename(file)
  position = 0
  error = nil

  contents.scan(/\-+(\w+)?/) do |match|
    samples << {contents[position, match.begin.not_nil! - position], error}
    position = match.end.not_nil!
    error = match[1]?
  end

  samples << {contents[position, contents.size - position], error}

  samples.each do |sample|
    source, error = sample
    result = nil

    it name do
      # Parse source
      ast = Parser.parse(source, file)
      ast.class.should eq(Ast)

      if error
        begin
          type_checker = TypeChecker.new(ast)
          type_checker.check
        rescue item : TypeError
          result = item
          item.class.name.split("::").last.should eq(error)
        end
        item.should be_a(TypeError)
      else
        type_checker = TypeChecker.new(ast)
        type_checker.check
      end
    end
  end
end
