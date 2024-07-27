require 'Header'
require 'Title'
require 'Summary'
require 'Job'
require 'Text'
require 'Competence'

class Factory
    HEADER = "header"
    TITLE = "title"
    SUMMARY = "summary"
    JOB = "job"
    TEXT = "text"
    COMPETENCE = "competence"

    def self.create_class(type, document, data, theme, available_width)
        case type
        when HEADER
          return Header.new(document, data, theme, available_width)
        when TITLE
          return Title.new(document, data, theme, available_width)
        when SUMMARY
          return Summary.new(document, data, theme, available_width)
        when JOB
          return Job.new(document, data, theme, available_width)
        when TEXT
          return Text.new(document, data, theme, available_width)
        when COMPETENCE
          return Competence.new(document, data, theme, available_width)
        else
          raise "Type of class not valid: #{type}"
        end
    end
end
