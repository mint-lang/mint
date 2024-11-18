module Mint
  class Parser
    def self.parse?(contents, file) : Ast | Error
      parser = new(contents, file)
      parser.parse
      parser.eof!
      parser.errors.first? || parser.ast
    end

    def self.parse(contents, file) : Ast
      case result = parse?(contents, file)
      in Error
        raise result
      in Ast
        result
      end
    end

    def self.parse(file) : Ast
      parse ::File.read(file), file
    end

    def self.parse_any(contents, file) : Ast
      new(contents, file).tap(&.parse_any).ast
    end

    def self.parse_any(file) : Ast
      parse_any ::File.read(file), file
    end

    def parse : Nil
      # Comment needs to be last since other comments are parsed with the
      # entities.
      items = many do
        module_definition ||
          type_definition ||
          component ||
          provider ||
          locale ||
          routes ||
          store ||
          suite ||
          comment
      end

      items.each do |item|
        case item
        when Ast::TypeDefinition
          ast.type_definitions << item
        when Ast::Component
          ast.components << item
        when Ast::Provider
          ast.providers << item
        when Ast::Comment
          ast.comments << item
        when Ast::Locale
          ast.locales << item
        when Ast::Module
          ast.modules << item
        when Ast::Routes
          ast.routes << item
        when Ast::Store
          ast.stores << item
        when Ast::Suite
          ast.suites << item
        end
      end
    end

    def parse_any : Nil
      many do
        oneof do
          module_definition ||
            type_definition ||
            html_attribute ||
            interpolation ||
            css_font_face ||
            css_keyframes ||
            component ||
            constant ||
            property ||
            provider ||
            function ||
            comment ||
            connect ||
            locale ||
            routes ||
            signal ||
            route ||
            state ||
            style ||
            store ||
            suite ||
            test ||
            emit ||
            get ||
            use ||
            statement ||
            case_branch ||
            destructuring ||
            css_node ||
            expression
        end
      end
    end
  end
end
