module Mint
  class Parser
    def enum_record_definition
      start do |start_position|
        fields =
          list(
            terminator: ')',
            separator: ','
          ) { record_definition_field }.compact

        skip if fields.empty?

        Ast::EnumRecordDefinition.new(
          from: start_position,
          fields: fields,
          to: position,
          input: data)
      end
    rescue error : SyntaxError
      nil
    end

    def enum_record : Ast::EnumRecord?
      start do |start_position|
        fields =
          list(
            terminator: ')',
            separator: ','
          ) { record_field }.compact

        skip if fields.empty?

        Ast::EnumRecord.new(
          from: start_position,
          fields: fields,
          to: position,
          input: data)
      end
    rescue error : SyntaxError
      nil
    end
  end

  class Ast
    class EnumRecord < Record
    end

    class EnumRecordDefinition < Node
      getter fields

      def initialize(@fields : Array(RecordDefinitionField),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end

  class TypeChecker
    def check(node : Ast::EnumRecordDefinition) : Checkable
      fields =
        node
          .fields
          .to_h { |field| {field.key.value, resolve(field).as(Checkable)} }

      mappings =
        node
          .fields
          .to_h { |field| {field.key.value, field.mapping.try(&.string_value)} }

      Record.new("", fields, mappings)
    end
  end

  class Parser
    syntax_error RecordExpectedClosingBracket

    def record : Ast::Record?
      start do |start_position|
        skip unless char! '{'

        fields = [] of Ast::RecordField

        unless char! '}'
          whitespace

          fields.concat(
            list(
              terminator: '}',
              separator: ','
            ) { record_field }.compact)

          whitespace
          char '}', RecordExpectedClosingBracket
        end

        Ast::Record.new(
          from: start_position,
          fields: fields,
          to: position,
          input: data)
      end
    end
  end
end
