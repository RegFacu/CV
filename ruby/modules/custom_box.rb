require 'prawn'

class CustomBox < Prawn::Text::Box
  include Prawn::View

  attr_accessor :initial_text, :measured_width

  def initialize(text, options = {})
    super
    @initial_text = text
  end

  def render(options = {})
    super
    @measured_width = width_of(@initial_text, size: @font_size) unless defined?(options[:dry_run]).nil?
  end
end
