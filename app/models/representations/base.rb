module Representations
  class Base
    def ordinalize(number)
      suffix =
        case number.to_s.split("").last
        when "1"; "st"
        when "2"; "nd"
        when "3"; "rd"
        else; "th"
        end

      "#{number}#{suffix}"
    end
  end
end
