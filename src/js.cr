module Mint
  abstract class Renderer
    abstract def object(hash : Hash(Codegen::Node, Codegen::Node)) : Codegen::Node
    abstract def function(name : Codegen::Node, arguments : Array(Codegen::Node), body : Codegen::Node) : Codegen::Node
    abstract def arrow_function(arguments : Array(Codegen::Node), body : Codegen::Node) : Codegen::Node
    abstract def const(name : String, value : Codegen::Node) : Codegen::Node
    abstract def class(name : String | Codegen::SourceMappable, extends : Codegen::Node, body : Array(Codegen::Node)) : Codegen::Node
    abstract def assign(name : Codegen::Node, value : Codegen::Node) : Codegen::Node
    abstract def statements(items : Array(Codegen::Node)) : Codegen::Node
    abstract def ifchain(items : Array(Tuple(Codegen::Node?, Codegen::Node))) : Codegen::Node
    abstract def store(name : Codegen::Node, body : Array(Codegen::Node)) : Codegen::Node
    abstract def module(name : String, body : Array(Codegen::Node)) : Codegen::Node
    abstract def provider(name : String, body : Array(Codegen::Node)) : Codegen::Node
    abstract def iif(body : Codegen::Node) : Codegen::Node
    abstract def asynciif(body : Codegen::Node) : Codegen::Node
    abstract def get(name : Codegen::Node, body : Codegen::Node) : Codegen::Node
    abstract def if(condition : Codegen::Node, body : Codegen::Node) : Codegen::Node
    abstract def elseif(condition : Codegen::Node, &block : Proc(Codegen::Node)) : Codegen::Node
    abstract def else(&block : Proc(Codegen::Node)) : Codegen::Node
    abstract def catch(condition : Codegen::Node, body : Codegen::Node) : Codegen::Node
    abstract def try(body : Codegen::Node, catches : Array(Codegen::Node), finally : Codegen::Node?) : Codegen::Node
    abstract def promise(body : Codegen::Node) : Codegen::Node
    abstract def array(items : Array(Codegen::Node)) : Codegen::Node
    abstract def display_name(name : String, real_name : String) : String
    abstract def css_rule(name : String, definitions : Array(String)) : String
    abstract def css_rules(rules : Array(String)) : String
    abstract def for(condition : Codegen::Node, body : Codegen::Node) : Codegen::Node

    def ifchain(items : Array(Tuple(Codegen::Node?, Codegen::Node))) : Codegen::Node
      converted =
        items
          .sort_by { |(condition, _)| condition.nil? ? 1 : -1 }
          .map_with_index do |(condition, body), index|
            case {index, condition}
            when {0, nil}
              body # This branch handles only one item which does not have condition
            when {_, nil}
              self.else { body }
            when {0, _}
              self.if(condition, body)
            else
              self.elseif(condition) { body }
            end
          end

      Codegen.join(converted, " ")
    end
  end

  class Optimized < Renderer
    def for(condition, body) : Codegen::Node
      Codegen.join ["for(", condition, "){", body, "}"]
    end

    def css_rule(name, definitions) : String
      "#{name}{#{definitions.join}}"
    end

    def css_rules(rules) : String
      rules.join
    end

    def display_name(name, real_name) : String
      ""
    end

    def object(hash : Hash(Codegen::Node, Codegen::Node)) : Codegen::Node
      body_parts = [] of Codegen::Node
      hash.each do |key, value|
        body_parts << Codegen.join [key, ":", value]
      end

      Codegen.join ["{", Codegen.join(body_parts, ","), "}"]
    end

    def function(name : Codegen::Node, arguments : Array(Codegen::Node), body : Codegen::Node) : Codegen::Node
      Codegen.join [name, "(", Codegen.join(arguments, ","), "){", body, "}"]
    end

    def arrow_function(arguments : Array(Codegen::Node), body : Codegen::Node) : Codegen::Node
      Codegen.join ["((", Codegen.join(arguments, ", "), ")=>{", body, "})"]
    end

    def const(name : String, value : Codegen::Node) : Codegen::Node
      Codegen.join ["const ", name, "=", value]
    end

    def assign(name : Codegen::Node, value : Codegen::Node) : Codegen::Node
      Codegen.join [name, "=", value]
    end

    def class(name : String | Codegen::SourceMappable, extends : Codegen::Node, body : Array(Codegen::Node)) : Codegen::Node
      Codegen.join ["class ", name, " extends ", extends, "{", Codegen.join(body), "}"]
    end

    def statements(items : Array(Codegen::Node)) : Codegen::Node
      Codegen.join(items, ";")
    end

    def store(name : Codegen::Node, body : Array(Codegen::Node)) : Codegen::Node
      const(name, Codegen.join ["new(class extends _S{", Codegen.join(body), "})"])
    end

    def module(name : String, body : Array(Codegen::Node)) : Codegen::Node
      const(name, Codegen.join ["new(class extends _M{", Codegen.join(body), "})"])
    end

    def provider(name : String, body : Array(Codegen::Node)) : Codegen::Node
      const(name, Codegen.join ["new(class extends _P{", Codegen.join(body), "})"])
    end

    def iif(body : Codegen::Node) : Codegen::Node
      Codegen.join ["(()=>{", body, "})()"]
    end

    def asynciif(body : Codegen::Node) : Codegen::Node
      Codegen.join ["(async()=>{", body, "})()"]
    end

    def get(name : Codegen::Node, body : Codegen::Node) : Codegen::Node
      Codegen.join ["get ", name, "(){", body, "}"]
    end

    def if(condition : Codegen::Node, body : Codegen::Node) : Codegen::Node
      Codegen.join ["if(", condition, "){", body, "}"]
    end

    def elseif(condition : Codegen::Node, &block : Proc(Codegen::Node)) : Codegen::Node
      Codegen.join ["else if(", condition, "){", yield, "}"]
    end

    def else(&block : Proc(Codegen::Node)) : Codegen::Node
      Codegen.join ["else{", yield, "}"]
    end

    def catch(condition : Codegen::Node, body : Codegen::Node) : Codegen::Node
      Codegen.join ["catch(", condition, "){", body, "}"]
    end

    def try(body : Codegen::Node, catches : Array(Codegen::Node), finally : Codegen::Node?) : Codegen::Node
      Codegen.join ["try{", body, "}", Codegen.join(catches), finally].compact
    end

    def promise(body : Codegen::Node) : Codegen::Node
      Codegen.join ["new Promise(", body, ")"]
    end

    def array(items : Array(Codegen::Node)) : Codegen::Node
      Codegen.join ["[", Codegen.join(items, ","), "]"]
    end
  end

  class Normal < Renderer
    def for(condition, body) : Codegen::Node
      Codegen.join ["for (", condition, ") ", class_body(body)]
    end

    def css_rule(name, definitions) : String
      "#{name} {\n#{definitions.join('\n').indent}\n}"
    end

    def css_rules(rules) : String
      rules.join("\n\n")
    end

    def display_name(name, real_name) : String
      %(#{name}.displayName = "#{real_name}")
    end

    def object(hash : Hash(Codegen::Node, Codegen::Node)) : Codegen::Node
      if hash.empty?
        "{}"
      else
        body_parts = [] of Codegen::Node
        hash.each do |key, value|
          body_parts << Codegen.join [key, ": ", value]
        end

        Codegen.join ["{\n", Codegen.indent(Codegen.join(body_parts, ",\n")), "\n}"]
      end
    end

    def function(name : Codegen::Node, arguments : Array(Codegen::Node), body : Codegen::Node) : Codegen::Node
      Codegen.join [name, "(", Codegen.join(arguments, ", "), ") ", class_body(body)]
    end

    def arrow_function(arguments : Array(Codegen::Node), body : Codegen::Node) : Codegen::Node
      Codegen.join ["(", Codegen.join(arguments, ", "), ") => ", class_body(body)]
    end

    def const(name : String, value : Codegen::Node) : Codegen::Node
      Codegen.join ["const ", name, " = ", value]
    end

    def class(name : String | Codegen::SourceMappable, extends : Codegen::Node, body : Array(Codegen::Node)) : Codegen::Node
      Codegen.join ["class ", name, " extends ", extends, " ", class_body(body)]
    end

    def assign(name : Codegen::Node, value : Codegen::Node) : Codegen::Node
      Codegen.join [name, " = ", value]
    end

    def statements(items : Array(Codegen::Node)) : Codegen::Node
      nodes =
        items.each_with_index.reduce([] of Codegen::Node) do |memo, (item, index)|
          last = items[index - 1]? if index > 0

          if last
            if Codegen.includes_endl? last
              memo << "\n\n"
            elsif Codegen.includes_endl? item
              memo << "\n\n"
            else
              memo << "\n"
            end
          end

          memo << item
          memo << ";" unless Codegen.ends_with?(';', Codegen.join memo)
          memo
        end

      Codegen.join nodes
    end

    def store(name : Codegen::Node, body : Array(Codegen::Node)) : Codegen::Node
      const(name, Codegen.join ["new(class extends _S ", class_body(body), ")"])
    end

    def module(name : String, body : Array(Codegen::Node)) : Codegen::Node
      const(name, Codegen.join ["new(class extends _M ", class_body(body), ")"])
    end

    def provider(name : String, body : Array(Codegen::Node)) : Codegen::Node
      const(name, Codegen.join ["new(class extends _P ", class_body(body), ")"])
    end

    def iif(body : Codegen::Node) : Codegen::Node
      Codegen.join ["(() => ", class_body(body), ")()"]
    end

    def asynciif(body : Codegen::Node) : Codegen::Node
      Codegen.join ["(async () => ", class_body(body), ")()"]
    end

    def get(name : Codegen::Node, body : Codegen::Node) : Codegen::Node
      Codegen.join ["get ", name, "() ", class_body(body)]
    end

    def if(condition : Codegen::Node, body : Codegen::Node) : Codegen::Node
      Codegen.join ["if (", condition, ") ", class_body(body)]
    end

    def elseif(condition, &block : Proc(Codegen::Node)) : Codegen::Node
      Codegen.join ["else if (", condition, ") ", class_body(yield)]
    end

    def else(&block : Proc(Codegen::Node)) : Codegen::Node
      Codegen.join ["else ", class_body(yield)]
    end

    def catch(condition : Codegen::Node, body : Codegen::Node) : Codegen::Node
      Codegen.join ["catch (", condition, ") ", class_body(body)]
    end

    def try(body : Codegen::Node, catches : Array(Codegen::Node), finally : Codegen::Node?) : Codegen::Node
      finally = Codegen.join [" ", finally] unless finally.nil? || Codegen.empty? finally
      Codegen.join ["try ", class_body(body), " ", Codegen.join(catches, "\n "), finally].compact
    end

    def promise(body : Codegen::Node) : Codegen::Node
      Codegen.join ["new Promise(", body, ")"]
    end

    def array(items : Array(Codegen::Node)) : Codegen::Node
      if items.empty?
        "[]"
      else
        Codegen.join ["[\n", Codegen.indent(Codegen.join(items, ",\n")), "\n]"]
      end
    end

    private def class_body(body : Codegen::Node)
      Codegen.join ["{\n", Codegen.indent(body), "\n}"]
    end

    private def class_body(body : Array(Codegen::Node))
      Codegen.join ["{\n", Codegen.indent(Codegen.join(body, "\n\n")), "\n}"]
    end
  end

  class Js
    INITIAL = 'a'.pred.to_s

    @style_prop_cache : Hash(String, String) = {} of String => String
    @style_cache : Hash(Ast::Node, String) = {} of Ast::Node => String

    @cache : Hash(Ast::Node, Codegen::Node) = {} of Ast::Node => Codegen::Node

    @type_cache : Hash(String, String) = {} of String => String

    @next_variable : String = 'a'.pred.to_s
    @next_class : String = 'A'.pred.to_s
    @next_style : String = 'a'.pred.to_s

    getter? optimize = true
    getter renderer

    forward_missing_to renderer

    def initialize(@optimize)
      @renderer = optimize ? Optimized.new : Normal.new
    end

    def variable_of(node : Ast::Node) : Codegen::Node
      case node
      when Ast::Function
        return node.name.value if node.keep_name?
      end

      @cache[node] ||= next_variable
    end

    def class_of(name : String) : String
      @type_cache[name] ||= next_class
    end

    def class_of(node : Ast::Node) : String
      val = (@cache[node] ||= next_class)
      case val
      when String
        val
      else raise "Can't determine class of #{typeof(node)}"
      end
    end

    def style_of(node : Ast::Node)
      @style_cache[node] ||= next_style
    end

    def style_next_property(name)
      @style_prop_cache[name] = (@style_prop_cache[name]? || INITIAL).succ
    end

    def variable
      next_variable
    end

    def let(name : Codegen::Node, value : Codegen::Node)
      Codegen.join ["let ", name, " = ", value]
    end

    def let(value : Codegen::Node)
      variable = next_variable

      {variable, Codegen.join ["let ", variable, " = ", value]}
    end

    def call(name : Codegen::Node, props : Array(Codegen::Node))
      props_joined = Codegen.join(props, ",")
      Codegen.join [name, "(", props_joined, ")"]
    end

    def function(name, arguments = [] of Codegen::Node) : Codegen::Node
      function(name, arguments, yield)
    end

    def return(value : Codegen::Node) : Codegen::Node
      if Codegen.empty? value
        "return"
      else
        Codegen.join ["return ", value]
      end
    end

    def asynciif
      asynciif(yield)
    end

    def iif
      iif(yield)
    end

    def catch(condition)
      catch(condition, yield)
    end

    def promise
      promise(yield)
    end

    def arrow_function(arguments : Array(Codegen::Node))
      arrow_function(arguments, yield)
    end

    def if(name)
      self.if(name, yield)
    end

    private def next_variable
      @next_variable = @next_variable.succ

      if @next_variable.in?("do", "in", "for", "if")
        next_variable
      else
        @next_variable
      end
    end

    private def next_style
      @next_style = @next_style.succ
    end

    private def next_class
      @next_class = @next_class.succ
    end
  end
end
