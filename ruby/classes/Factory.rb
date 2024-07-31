require 'Header'
require 'Title'
require 'Summary'
require 'Job'
require 'Text'
require 'Competence'
require 'Spacing'
require 'AlternativeHeader'
require 'Footer'

class Factory
    HEADER = "header"
    TITLE = "title"
    SUMMARY = "summary"
    JOB = "job"
    TEXT = "text"
    COMPETENCE = "competence"
    SPACING = "spacing"
    ALTERNATIVE_HEADER = "alternative_header"
    FOOTER = "footer"

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
        when SPACING
          return Spacing.new(document, data, theme, available_width)
        when ALTERNATIVE_HEADER
          return AlternativeHeader.new(document, data, theme, available_width)
        when FOOTER
          return Footer.new(document, data, theme, available_width)
        else
          raise "Type of class not valid: #{type}"
        end
    end
end
