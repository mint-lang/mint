module Mint
  class TypeChecker
    def check_locale(node : Ast::Locale)
      node.fields.each do |field|
        check_locale_record(
          language: node.language,
          prefix: nil,
          node: field)
      end
    end

    def check_locale_record(
      *,
      language : String,
      node : Ast::Field,
      prefix : String?
    )
      return unless key = node.key

      field_prefix =
        if prefix
          "#{prefix}.#{key.value}"
        else
          key.value
        end

      case item = node.value
      when Ast::Record
        item.fields.each do |field|
          check_locale_record(
            prefix: field_prefix,
            language: language,
            node: field)
        end
      else
        locales[field_prefix] ||= {} of String => Ast::Node
        locales[field_prefix][language] = item
      end
    end
  end
end
