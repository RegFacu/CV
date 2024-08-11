require 'prawn'

# Draw an empty row in the PDF document. Usually used to add a gap between 2 elements
class Spacing
  include Prawn::View

  def initialize(document, data, theme, available_width)
    @document = document
    @theme = theme
    @available_width = available_width
    @spacing = @theme.spacing[data.spacing]
  end

  def fit(_horizontal_cursor, remaining_space)
    @spacing < remaining_space
  end

  def write_content(_horizontal_cursor)
    move_down @spacing
  end
end
