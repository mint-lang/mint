module Mint
  class Parser
    def self.parse(file) : Ast
      parse File.read(file), file
    end

    def self.parse(contents, file) : Ast
      parser = new(contents, file)
      parser.top_levels
      parser.eof!
      parser.ast
    end

    def eof! : Nil
      whitespace
      error :expected_eof { expected "the end of the file", word } unless char == '\0'
      true
    end

    def top_levels : Nil
      items = many do
        component ||
          module_definition ||
          record_definition ||
          self.enum ||
          provider ||
          locale ||
          routes ||
          store ||
          suite ||
          comment
      end

      items.each do |item|
        case item
        when Ast::Suite
          @ast.suites << item
        when Ast::Provider
          @ast.providers << item
        when Ast::RecordDefinition
          @ast.records << item
        when Ast::Component
          @ast.components << item
        when Ast::Module
          @ast.modules << item
        when Ast::Store
          @ast.stores << item
        when Ast::Routes
          @ast.routes << item
        when Ast::Enum
          @ast.enums << item
        when Ast::Comment
          @ast.comments << item
        when Ast::Locale
          @ast.locales << item
        end
      end
    end
  end
end
