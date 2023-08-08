module Mint
  class Parser
    def css_selector_name : String?
      if ampersand = char! '&'
        double_colon = word!("::")
        bracket = char!('[')
        colon = char!(':')
        dot = char!('.')
      end

      name =
        gather { chars { |char| !char.in?(',', '{', '}') } }.presence.try(&.strip)

      return unless name || ampersand

      case
      when double_colon then "::#{name}"
      when bracket      then "[#{name}"
      when colon        then ":#{name}"
      when dot          then ".#{name}"
      else                   " #{name}"
      end
    end
  end
end
