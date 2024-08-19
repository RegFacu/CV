require 'prawn'

# Draw a row in the PDF document with 2 columns:
# - On the left column, text elements are displayed
# - On the right column, competence elements are displayed
class Summary
  include Prawn::View

  def initialize(document, data, theme, available_width)
    @document = document
    @theme = theme
    @available_width = available_width
    @space_between_columns = @theme.spacing[@theme.components.summary.space_between_columns]
    @space_between_rows = @theme.spacing[@theme.components.summary.space_between_rows]

    initialize_columns(data.description, data.competences)
  end

  def initialize_columns(description, competences)
    @left_column = []
    @right_column = []

    @left_column_width = @theme.components.summary.left_column_width
    @right_column_width = @available_width - @left_column_width - @space_between_columns
    description.each do |object|
      @left_column << Factory.create_class(Factory::TEXT, @document, object, @theme, @left_column_width)
    end
    competences.sort_by(&:value).reverse.each do |object|
      @right_column << Factory.create_class(Factory::COMPETENCE, @document, object, @theme, @right_column_width)
    end
  end

  def fit(horizontal_cursor, remaining_space)
    measure_height(horizontal_cursor) <= remaining_space
  end

  def measure_height(horizontal_cursor)
    [measure_left_column_height(horizontal_cursor), measure_right_column_height(horizontal_cursor)].max
  end

  def measure_left_column_height(horizontal_cursor)
    left_column_height = 0
    @left_column.each_with_index do |element, index|
      left_column_height += @space_between_rows if index.positive?
      left_column_height += element.measure_height(horizontal_cursor)
    end
    left_column_height
  end

  def measure_right_column_height(horizontal_cursor)
    right_column_height = 0
    @right_column.each_with_index do |element, index|
      right_column_height += @space_between_rows if index.positive?
      right_column_height += element.measure_height(horizontal_cursor)
    end
    right_column_height
  end

  def write_content(horizontal_cursor)
    original_cursor_position = cursor
    write_left_column(horizontal_cursor)
    left_cursor_position = cursor

    move_cursor_to original_cursor_position
    write_right_column(horizontal_cursor)

    move_cursor_to [left_cursor_position, cursor].min
  end

  def write_left_column(horizontal_cursor)
    @left_column.each_with_index do |element, index|
      move_down @space_between_rows if index.positive?
      element.write_content(horizontal_cursor)
    end
  end

  def write_right_column(horizontal_cursor)
    @right_column.each_with_index do |element, index|
      move_down @space_between_rows if index.positive?
      element.write_content(horizontal_cursor + @left_column_width + @space_between_columns)
    end
  end
end
