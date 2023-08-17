require "./spec_helper"

Dir
  .glob("./spec/type_checking/**/*")
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    # Read samples
    samples = [] of Tuple(String, String?)
    contents = File.read(file)
    name = File.basename(file)
    position = 0
    error = nil

    contents.scan(/^\-+(\w+)?/m) do |match|
      samples << {contents[position, match.begin - position], error}
      position = match.end
      error = match[1]?
    end

    samples << {contents[position, contents.size - position], error}

    samples.each_with_index do |sample, index|
      it "#{name} ##{index}" do
        source, error = sample

        ast = Mint::Ast.new

        # Parse source
        if error
          begin
            ast = Mint::Parser.parse(source, file)
            ast.class.should eq(Mint::Ast)

            type_checker = Mint::TypeChecker.new(ast)
            type_checker.check

            type_checker.cache.size.should_not eq(0)
          rescue item : Mint::Error2
            item.class.name.split("::").last.should eq(error)
          end

          item.should be_a(Mint::Error2)

          # Check if they are rendered correctly.
          item.try(&.to_terminal)
          item.try(&.to_html)
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
