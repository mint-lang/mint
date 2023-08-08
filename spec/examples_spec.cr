require "./spec_helper"

path = "./spec/examples/**/*"
example = nil

ENV["EXAMPLE"]?.try do |item|
  splitted = item.split(':', 2)
  path = splitted[0]
  example = splitted[1]?
end

Dir
  .glob(path)
  .select! { |file| File.file?(file) }
  .sort!
  .each do |file|
    # Read samples
    samples = [] of Tuple(String, String?)
    contents = File.read(file)
    name = File.basename(file)
    position = 0
    error = nil

    contents.scan(/^\-+([^-\n]+)?/m) do |match|
      subject = contents[position, match.begin - position]
      samples << {subject, error}
      position = match.end
      error = match[1]?
    end

    samples << {contents[position, contents.size - position], error}

    samples.reject(&.first?.blank?).each_with_index do |sample, index|
      next if example && example.to_i != index

      it "#{name} ##{index}" do
        source, error = sample

        # Parse source
        if error
          begin
            ast = Mint::Parser.parse(source, file)
            ast.class.should eq(Mint::Ast)

            type_checker = Mint::TypeChecker.new(ast)
            type_checker.check

            type_checker.cache.size.should_not eq(0)
          rescue item : Mint::Error2
            item.name.to_s.should eq(error)
          end

          item.should be_a(Mint::Error2)

          # Check if they are rendered correctly.
          # item.try(&.to_terminal)
          # item.try(&.to_html)
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
