require "./spec_helper"

Dir.glob("./spec/type_checking/**").sort.each do |file|
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

    it "#{name} ##{index}" do
      ast = Mint::Ast.new

      # Parse source
      if error
        begin
          ast = Mint::Parser.parse(source, file)
          ast.class.should eq(Mint::Ast)

          type_checker = Mint::TypeChecker.new(ast)
          type_checker.check

          type_checker.cache.size.should_not eq(0)
        rescue item : Mint::Error
          item.class.name.split("::").last.should eq(error)
        end

        item.should be_a(Mint::Error)
      else
        ast = Mint::Parser.parse(source, file)
        ast.class.should eq(Mint::Ast)

        type_checker = Mint::TypeChecker.new(ast)
        type_checker.check

        type_checker.cache.size.should_not eq(0)
      end
    end
  end
end
