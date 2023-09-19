module Mint
  class TypeChecker
    def check_locale(node : Ast::Locale)
      node.fields.each do |field|
        check_locale_record(field, nil, node.language)
      end
    end

    def check_locale_record(node : Ast::Field, prefix : String?, language : String)
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
          check_locale_record(field, field_prefix, language)
        end
      else
        locales[field_prefix] ||= {} of String => Ast::Node
        locales[field_prefix][language] = item
      end
    end
  end
end
