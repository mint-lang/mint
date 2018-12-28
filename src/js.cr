module Mint
  abstract class Renderer
    abstract def object(hash : Hash(String, String)) : String
    abstract def function(name, arguments : Array(String), body : String) : String
    abstract def arrow_function(arguments : Array(String), body : String) : String
    abstract def const(name : String, value : String) : String
    abstract def class(name : String, extends : String, body : Array(String)) : String
    abstract def assign(name : String, value : String) : String
    abstract def statements(items : Array(String)) : String
    abstract def store(name : String, body : Array(String)) : String
    abstract def iic(body : Array(String)) : String
    abstract def iif(body : String) : String
    abstract def asynciif(body : String) : String
    abstract def get(name : String, body : String) : String
    abstract def if(condition : String, body : String) : String
    abstract def catch(condition : String, body : String) : String
    abstract def try(body : String, catches : Array(String), finally : String) : String
    abstract def promise(body : String) : String
  end

  class Optimized < Renderer
    def object(hash : Hash(String, String)) : String
      body =
        hash
          .map { |key, value| "#{key}:#{value}" }
          .join(",")

      "{#{body}}"
    end

    def function(name : String, arguments : Array(String), body : String) : String
      "#{name}(#{arguments.join(",")}){#{body}}"
    end

    def arrow_function(arguments : Array(String), body : String) : String
      "(#{arguments.join(", ")})=>{#{body}}"
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
      items.join(";")
    end

    def store(name : String, body : Array(String)) : String
      const(name, "new(class extends Store{#{body.join("")}})")
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

    def get(name : String, body : String)
      "get #{name}(){#{body}}"
    end

    def if(condition : String, body : String)
      "if(#{condition}){#{body}}"
    end

    def catch(condition : String, body : String)
      "catch(#{condition}){#{body}}"
    end

    def try(body : String, catches : Array(String), finally : String) : String
      "try{#{body}}#{catches.join("")}#{finally}"
    end

    def promise(body : String) : String
      "new Promise(#{body})"
    end
  end

  class Normal < Renderer
    def object(hash : Hash(String, String)) : String
      body =
        hash
          .map { |key, value| "#{key}: #{value}" }
          .join(",\n")

      "{\n#{body.indent}\n}"
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
        next_item = items[index + 1]?

        if last
          if last.includes?("\n")
            memo += "\n\n"
          elsif item.includes?("\n")
            memo += "\n\n"
          else
            memo += "\n"
          end
        end

        memo += item
        memo
      end
    end

    def store(name : String, body : Array(String)) : String
      const(name, "new(class extends Store #{class_body(body)})")
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

    def if(condition : String, body : String)
      "if (#{condition}) #{class_body(body)}"
    end

    def catch(condition : String, body : String)
      "catch (#{condition}) #{class_body(body)}"
    end

    def try(body : String, catches : Array(String), finally : String) : String
      finally = " #{finally}" unless finally.empty?
      "try #{class_body(body)} #{catches.join("\n ")}#{finally}"
    end

    def promise(body : String) : String
      "new Promise(#{body})"
    end

    private def class_body(body : String)
      "{\n#{body.indent}\n}"
    end

    private def class_body(body : Array(String))
      "{\n" + body.join("\n\n").indent + "\n}"
    end
  end

  class Js
    getter optimize, renderer

    @cache : Hash(Ast::Node, String) = {} of Ast::Node => String

    @next_variable : String = 'a'.pred.to_s
    @next_class : String = 'A'.pred.to_s

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
        return "render" if node.is_render
      end

      @cache[node] ||= next_variable
    end

    def class_of(node)
      @cache[node] ||= next_class
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
      "#{name}(#{props.join(",")})"
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
    end

    private def next_class
      @next_class = @next_class.succ
    end
  end
end
