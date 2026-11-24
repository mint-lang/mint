module Mint
  class TypeChecker
    # The types of provided values are checked against the values they are
    # given to in the requirements pass, since a name can have different
    # types on different paths.
    def check(node : Ast::Provide) : Checkable
      names = {} of String => Ast::Field

      node.fields.each do |field|
        next unless key = field.key

        if other = names[key.value]?
          error! :provide_multiple_values do
            block do
              text "The value"
              bold %("#{key.value}")
              text "is provided more than once:"
            end

            snippet other
            snippet field
          end
        end

        names[key.value] = field
        resolve field.value
      end

      resolve node.body
    end
  end
end
