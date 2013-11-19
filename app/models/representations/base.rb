module Representations
  class Base
    def ordinalize(number)
      ActiveSupport::Inflector.ordinalize(number)
    end
  end
end
