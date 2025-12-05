module Mint
  class TypeChecker
    module Comparer
      extend self

      def matches_any?(node, targets)
        targets.any? { |target| compare(node, target) }
      end

      def compare_as_promises(node1, node2, *, first_only : Bool = false)
        promise = false

        if node1.name != node2.name &&
           ((node1.name == "Promise" && node1.parameters.size == 1) ||
           (node2.name == "Promise" && node2.parameters.size == 1 && !first_only))
          node1 =
            node1.parameters.first if node1.name == "Promise"

          node2 =
            node2.parameters.first if node2.name == "Promise" && !first_only

          promise = true
        end

        compare(node1, node2).try do |resolved|
          if promise
            Type.new("Promise", [resolved] of Checkable)
          else
            resolved
          end
        end
      end

      def compare(node1, node2, *, expand : Bool = false)
        mapping = {} of Variable => Checkable
        unified = unify(node1, node2, mapping, expand: expand)
        fill2(unified, mapping)
      rescue
        nil
      end

      def fill2(node, mapping : Hash(Variable, Checkable))
        node = prune(node, mapping)

        case node
        when Variable
          mapping[node]? || node
        when Type
          parameters =
            node.parameters.map { |param| fill2(param, mapping).as(Checkable) }

          variants =
            node.variants.compact_map do |variant|
              case item = fill2(variant, mapping).as(Checkable)
              when Type
                item
              end
            end

          Type.new(node.name, parameters, node.label, variants)
        else
          node
        end
      end

      def fill(node, mapping : Hash(String, Checkable))
        case node
        when Variable
          mapping[node.name]? || node
        when Type
          parameters =
            node.parameters.map { |param| fill(param, mapping).as(Checkable) }

          variants =
            node.variants.compact_map do |variant|
              case item = fill(variant, mapping).as(Checkable)
              when Type
                item
              end
            end

          Type.new(node.name, parameters, node.label, variants)
        else
          node
        end
      end

      def dbg(node : Checkable)
        case node
        when Variable
          if i = node.instance
            "#{node.name}:#{node.id} -> #{dbg(i)}"
          else
            "#{node.name}:#{node.id}"
          end
        when Type
          variants =
            unless node.variants.empty?
              node.variants.map(&->dbg(Checkable)).join(" | ")
            end

          base =
            if node.parameters.empty?
              node.name
            else
              "#{node.name}(#{node.parameters.map(&->dbg(Checkable)).join(", ")})"
            end

          if variants
            "#{base}<#{variants}>"
          else
            base
          end
        else
          node.to_s
        end
      end

      def unify(node1 : Checkable, node2 : Checkable, mapping : Hash(Variable, Checkable), *, expand : Bool) : Checkable
        # puts "#{dbg(node1)} <> #{dbg(node2)}"
        case
        when node1.is_a?(Variable)
          unless node1 == node2
            if occurs_in_type(node1, node2)
              raise "Recursive unification!"
            end
            mapping[node1] = node2
          end
          node1
        when node2.is_a?(Variable)
          unify(node2, node1, mapping, expand: expand)
        when node1.is_a?(Record) && node2.is_a?(Type)
          raise "Not unified!" unless node1.name == node2.name
          node1
        when node2.is_a?(Record) && node1.is_a?(Type)
          unify(node2, node1, mapping, expand: expand)
        when node1.is_a?(Record) && node2.is_a?(Record)
          raise "Not unified!" unless node1.fields.size == node2.fields.size
          node1.fields.each do |key, type|
            raise "Not unified!" unless node2.fields[key]?
            unify(type, node2.fields[key], mapping, expand: expand)
          end
          node1
        when node1.is_a?(Type) && node2.is_a?(Type)
          if node1.name != node2.name
            if node1.variants.size > 0 && node2.variants.size == 0 && expand
              if variant = node1.variants.find(&.name.==(node2.name))
                unify(variant, node2, mapping, expand: expand)
              else
                raise "Can't unify #{node1} with #{node2} no variant matches!"
              end
            else
              raise "Can't unify #{node1} with #{node2}!"
            end
          elsif node1.parameters.size != node2.parameters.size
            raise "Can't unify #{node1} with #{node2} parameter size mismatch!"
          else
            node1.parameters.each_with_index do |item, index|
              unify(item, node2.parameters[index], mapping, expand: expand)
            end
          end

          node1
        else
          raise "Not unified!"
        end
      end

      def occurs_in_type(node1, node2)
        return true if node1 == node2

        case node2
        when Type
          node2.parameters.any? { |type| occurs_in_type(node1, type) }
        else
          false
        end
      end

      def normalize(type : Type, mapping = {} of String => Variable)
        type.variants.map! do |variant|
          normalize(variant, mapping)
        end

        type.parameters.map! do |parameter|
          case parameter
          when Variable
            mapping[parameter.name]? || (mapping[parameter.name] = parameter)
          when Type
            normalize(parameter, mapping)
          else
            parameter
          end.as(Checkable)
        end

        type
      end

      def normalize(node : Record)
        node
      end

      def normalize(node : Variable)
        node
      end

      def prune(node : Variable, mapping : Hash(Variable, Checkable))
        mapping[node]?.try do |instance|
          prune(instance, mapping).tap(&.label=(node.label))
        end || node
      end

      def prune(node : Type, mapping : Hash(Variable, Checkable))
        parameters =
          node.parameters.map { |param| prune(param, mapping).as(Checkable) }

        variants =
          node.variants.compact_map do |variant|
            case item = prune(variant, mapping).as(Checkable)
            when Type
              item
            end
          end

        Type.new(node.name, parameters, node.label, variants)
      end

      def prune(node : Record, mapping : Hash(Variable, Checkable))
        node
      end
    end
  end
end
