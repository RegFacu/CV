require 'header'
require 'title'
require 'summary'
require 'job'
require 'text'
require 'competence'
require 'spacing'
require 'alternative_header'
require 'footer'

# Generate objects dynamically based on the type of element to be drawn.
class Factory
  HEADER = 'header'.freeze
  TITLE = 'title'.freeze
  SUMMARY = 'summary'.freeze
  JOB = 'job'.freeze
  TEXT = 'text'.freeze
  COMPETENCE = 'competence'.freeze
  SPACING = 'spacing'.freeze
  ALTERNATIVE_HEADER = 'alternative_header'.freeze
  FOOTER = 'footer'.freeze

  CLASSES = {
    HEADER => Header,
    TITLE => Title,
    SUMMARY => Summary,
    JOB => Job,
    TEXT => Text,
    COMPETENCE => Competence,
    SPACING => Spacing,
    ALTERNATIVE_HEADER => AlternativeHeader,
    FOOTER => Footer
  }.freeze

  def self.create_class(type, document, data, theme, available_width)
    generator_name = CLASSES[type]
    raise "Type of class not valid: #{type}" unless generator_name

    generator_name.new(document, data, theme, available_width)
  end
end
