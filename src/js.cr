module Mint
  abstract class Renderer
    abstract def object(hash : Hash(String, String)) : String
    abstract def function(name, arguments : Array(String), body : String) : String
    abstract def arrow_function(arguments : Array(String), body : String) : String
    abstract def const(name : String, value : String) : String
    abstract def class(name : String, extends : String, body : Array(String)) : String
    abstract def assign(name : String, value : String) : String
    abstract def statements(items : Array(String)) : String
    abstract def ifchain(items : Array(Tuple(String | Nil, String))) : String
    abstract def store(name : String, body : Array(String)) : String
    abstract def module(name : String, body : Array(String)) : String
    abstract def provider(name : String, body : Array(String)) : String
    abstract def iic(body : Array(String)) : String
    abstract def iif(body : String) : String
    abstract def asynciif(body : String) : String
    abstract def get(name : String, body : String) : String
    abstract def if(condition : String, body : String) : String
    abstract def elseif(condition, &block : Proc(String)) : String
    abstract def else(&block : Proc(String)) : String
    abstract def catch(condition : String, body : String) : String
    abstract def try(body : String, catches : Array(String), finally : String) : String
    abstract def promise(body : String) : String
    abstract def array(items : Array(String)) : String
    abstract def display_name(name : String, real_name : String) : String
    abstract def css_rule(name : String, definitions : Array(String)) : String
    abstract def css_rules(rules : Array(String)) : String
    abstract def for(condition : String, body : String) : String

    def ifchain(items : Array(Tuple(String | Nil, String))) : String
      items
        .sort_by { |(condition, _)| condition.nil? ? 1 : -1 }
        .map_with_index do |(condition, body), index|
          case
          when index == 0 && condition.nil?
            body # This branch handles only one item which does not have condition
          when condition.nil?
            self.else { body }
          when index == 0
            self.if(condition.to_s, body)
          else
            self.elseif(condition) { body }
          end
        end.join(' ')
    end
  end

  class Optimized < Renderer
    def for(condition, body) : String
      "for(#{condition}){#{body}}"
    end

    def css_rule(name, definitions) : String
      "#{name}{#{definitions.join("")}}"
    end

    def css_rules(rules) : String
      rules.join("")
    end

    def display_name(name, real_name) : String
      ""
    end

    def object(hash : Hash(String, String)) : String
      body =
        hash.join(',') { |key, value| "#{key}:#{value}" }

      "{#{body}}"
    end

    def function(name : String, arguments : Array(String), body : String) : String
      "#{name}(#{arguments.join(',')}){#{body}}"
    end

    def arrow_function(arguments : Array(String), body : String) : String
      "((#{arguments.join(", ")})=>{#{body}})"
    end

    def const(name : String, value : String) : String
      "const #{name}=#{value}"
    end

    def assign(name : String, value : String) : String
      "#{name}=#{value}"
    end

    def class(name, extends : String, body : Array(String)) : String
      "class #{name} extends #{extends}{#{body.join("")}}"
    end

    def statements(items : Array(String)) : String
      items.join(';')
    end

    def store(name : String, body : Array(String)) : String
      const(name, "new(class extends _S{#{body.join("")}})")
    end

    def module(name : String, body : Array(String)) : String
      const(name, "new(class extends _M{#{body.join("")}})")
    end

    def provider(name : String, body : Array(String)) : String
      const(name, "new(class extends _P{#{body.join("")}})")
    end

    def iic(body : Array(String)) : String
      "new(class{#{body.join("")}})"
    end

    def iif(body : String) : String
      "(()=>{#{body}})()"
    end

    def asynciif(body : String) : String
      "(async()=>{#{body}})()"
    end

    def get(name : String, body : String) : String
      "get #{name}(){#{body}}"
    end

    def if(condition : String, body : String) : String
      "if(#{condition}){#{body}}"
    end

    def elseif(condition, &block : Proc(String)) : String
      "else if(#{condition}){#{yield}}"
    end

    def else(&block : Proc(String)) : String
      "else{#{yield}}"
    end

    def catch(condition : String, body : String) : String
      "catch(#{condition}){#{body}}"
    end

    def try(body : String, catches : Array(String), finally : String) : String
      "try{#{body}}#{catches.join("")}#{finally}"
    end

    def promise(body : String) : String
      "new Promise(#{body})"
    end

    def array(items : Array(String)) : String
      "[#{items.join(',')}]"
    end
  end

  class Normal < Renderer
    def for(condition, body) : String
      "for (#{condition}) #{class_body(body)}"
    end

    def css_rule(name, definitions) : String
      "#{name} {\n#{definitions.join('\n').indent}\n}"
    end

    def css_rules(rules) : String
      rules.join("\n\n")
    end

    def display_name(name, real_name) : String
      "#{name}.displayName = \"#{real_name}\""
    end

    def object(hash : Hash(String, String)) : String
      if hash.empty?
        "{}"
      else
        body =
          hash.join(",\n") { |key, value| "#{key}: #{value}" }

        "{\n#{body.indent}\n}"
      end
    end

    def function(name : String, arguments : Array(String), body : String) : String
      "#{name}(#{arguments.join(", ")}) #{class_body(body)}"
    end

    def arrow_function(arguments : Array(String), body : String) : String
      "(#{arguments.join(", ")}) => #{class_body(body)}"
    end

    def const(name : String, value : String) : String
      "const #{name} = #{value}"
    end

    def class(name : String, extends : String, body : Array(String)) : String
      "class #{name} extends #{extends} #{class_body(body)}"
    end

    def assign(name : String, value : String) : String
      "#{name} = #{value}"
    end

    def statements(items : Array(String)) : String
      items.each_with_index.reduce("") do |memo, (item, index)|
        last = items[index - 1]? if index > 0

        if last
          if last.includes?('\n')
            memo += "\n\n"
          elsif item.includes?('\n')
            memo += "\n\n"
          else
            memo += "\n"
          end
        end

        memo += item
        memo += ";" unless memo.ends_with?(';')
        memo
      end
    end

    def store(name : String, body : Array(String)) : String
      const(name, "new(class extends _S #{class_body(body)})")
    end

    def module(name : String, body : Array(String)) : String
      const(name, "new(class extends _M #{class_body(body)})")
    end

    def provider(name : String, body : Array(String)) : String
      const(name, "new(class extends _P #{class_body(body)})")
    end

    def iic(body : Array(String)) : String
      "new(class #{class_body(body)})"
    end

    def iif(body : String) : String
      "(() => #{class_body(body)})()"
    end

    def asynciif(body : String) : String
      "(async () => #{class_body(body)})()"
    end

    def get(name : String, body : String) : String
      "get #{name}() #{class_body(body)}"
    end

    def if(condition : String, body : String) : String
      "if (#{condition}) #{class_body(body)}"
    end

    def elseif(condition, &block : Proc(String)) : String
      "else if (#{condition}) #{class_body(yield)}"
    end

    def else(&block : Proc(String)) : String
      "else #{class_body(yield)}"
    end

    def catch(condition : String, body : String) : String
      "catch (#{condition}) #{class_body(body)}"
    end

    def try(body : String, catches : Array(String), finally : String) : String
      finally = " #{finally}" unless finally.empty?
      "try #{class_body(body)} #{catches.join("\n ")}#{finally}"
    end

    def promise(body : String) : String
      "new Promise(#{body})"
    end

    def array(items : Array(String)) : String
      if items.empty?
        "[]"
      else
        "[\n#{items.join(",\n").indent}\n]"
      end
    end

    private def class_body(body : String)
      "{\n#{body.indent}\n}"
    end

    private def class_body(body : Array(String))
      "{\n" + body.join("\n\n").indent + "\n}"
    end
  end

  class Js
    INITIAL = 'a'.pred.to_s

    getter optimize, renderer

    @style_prop_cache : Hash(String, String) = {} of String => String
    @style_cache : Hash(Ast::Node, String) = {} of Ast::Node => String

    @cache : Hash(Ast::Node, String) = {} of Ast::Node => String

    @type_cache : Hash(String, String) = {} of String => String

    @next_variable : String = 'a'.pred.to_s
    @next_class : String = 'A'.pred.to_s
    @next_style : String = 'a'.pred.to_s

    @optimize = true

    forward_missing_to renderer

    def initialize(@optimize)
      @renderer =
        if optimize
          Optimized.new
        else
          Normal.new
        end
    end

    def variable_of(node)
      case node
      when Ast::Function
        return node.name.value if node.keep_name
      end

      @cache[node] ||= next_variable
    end

    def class_of(name : String)
      @type_cache[name] ||= next_class
    end

    def class_of(node : Ast::Node)
      @cache[node] ||= next_class
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

    def let(name, value)
      "let #{name} = #{value}"
    end

    def let(value)
      variable = next_variable

      {variable, "let #{variable} = #{value}"}
    end

    def call(name, props)
      "#{name}(#{props.join(',')})"
    end

    def function(name, arguments = [] of String) : String
      function(name, arguments, yield)
    end

    def return(value)
      if value.empty?
        "return"
      else
        "return #{value}"
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

    def arrow_function(arguments : Array(String))
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
