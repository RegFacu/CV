require 'prawn'

# Extend Prawn::Text::Box functionality by adding properties:
# - initial_text: Contains the text used to initialize the object
# - measured_width: Contains the measured text width when the class is rendered in dry_run mode
class CustomBox < Prawn::Text::Box
  include Prawn::View

  attr_accessor :initial_text, :measured_width

  def initialize(text, options = {})
    super
    @initial_text = text
  end

  def render(options = {})
    super
    @measured_width = width_of(@initial_text, size: @font_size) if options[:dry_run]
  end
end
