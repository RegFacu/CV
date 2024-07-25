require 'Header'
require 'Title'

class Factory
    HEADER = "header"
    TITLE = "title"
    JOB = "job"

    def self.create_class(type, document, data, theme)
        case type
        when HEADER
          return Header.new(document, data, theme)
        when TITLE
          return Title.new(document, data, theme)
        when JOB
          return Job.new(document, data, theme)
        else
          raise "Type of class not valid: #{type}"
        end
    end
end
