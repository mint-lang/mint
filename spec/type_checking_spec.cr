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

  samples.each_with_index do |sample, index|
    source, error = sample
    result = nil

    it "#{name} ##{index}" do
      # Parse source
      ast = Mint::Parser.parse(source, file)
      ast.class.should eq(Mint::Ast)

      if error
        begin
          type_checker = Mint::TypeChecker.new(ast)
          type_checker.check
        rescue item : Mint::TypeError
          result = item
          item.class.name.split("::").last.should eq(error)
        end
        item.should be_a(Mint::TypeError)
      else
        type_checker = Mint::TypeChecker.new(ast)
        type_checker.check
      end
    end
  end
end
