require 'Header'

class Factory
    HEADER = "header"

    def self.create_class(type, document, data, theme)
        case type
        when HEADER
          return Header.new(document, data, theme)
        else
          raise "Type of class not valid: #{type}"
        end
    end
end
