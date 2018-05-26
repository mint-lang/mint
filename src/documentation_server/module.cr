module Mint
  class DocumentationServer
    def generate(node : Ast::Module)
      page do |t|
        title node.name, t

        if node.functions.any?
          subtitle "Functions", t
          generate node.functions, t
        end
      end
    end
  end
end

module Mint
  class DocumentationServer
    def generate(node : Ast::Component)
      page do |t|
        title node.name, t

        if node.properties.any?
          subtitle "Properties", t
          generate node.properties, t
        end

        if node.gets.any?
          subtitle "Computed Properties", t
          generate node.gets, t
        end

        if node.functions.any?
          subtitle "Functions", t
          generate node.functions, t
        end
      end
    end
  end
end

module Mint
  class DocumentationServer
    def generate(node : Ast::Store)
      page do |t|
        title node.name, t

        if node.properties.any?
          subtitle "Properties", t
          generate node.properties, t
        end

        if node.functions.any?
          subtitle "Functions", t
          generate node.functions, t
        end
      end
    end
  end
end

module Mint
  class DocumentationServer
    def generate(node : Ast::Function, t)
      t.div class: "function" do
        t.div class: "function__definition" do
          t.div node.name.value, class: "function__name"

          if node.arguments.any?
            t.text " ("
            generate node.arguments, t
            t.text ")"
          end

          t.text " : "
          generate node.type, t
          format node, t
        end
      end
    end
  end
end

module Mint
  class DocumentationServer
    def generate(node : Ast::Get, t)
      t.div class: "function" do
        t.div class: "function__definition" do
          t.div node.name.value, class: "function__name"
          t.text " : "
          generate node.type, t
          format node, t
        end
      end
    end
  end
end

module Mint
  class DocumentationServer
    def generate(node : Ast::Property, t)
      t.div class: "function" do
        t.div class: "function__definition" do
          t.div node.name.value, class: "function__name"
          t.text " : "
          generate node.type, t
          t.text " = "

          default = @formatter.format(node.default)

          if default.includes?("\n")
            t.div default, class: "property__default"
          else
            t.div default, class: "property__default-inline"
          end
        end
      end
    end
  end
end

module Mint
  class DocumentationServer
    def generate(node : Ast::Argument, t)
      t.div class: "function__argument" do
        t.text node.name.value
        t.text " : "

        generate node.type, t
      end
    end
  end
end

module Mint
  class DocumentationServer
    def generate(node : Ast::Type, t)
      t.div class: "type" do
        t.text node.name

        if node.parameters.any?
          t.text "("
          generate node.parameters, t
          t.text ")"
        end
      end
    end
  end
end

module Mint
  class DocumentationServer
    def generate(node : Ast::TypeVariable, t)
      t.div class: "type" do
        t.text node.value
      end
    end
  end
end
