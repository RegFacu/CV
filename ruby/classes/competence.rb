require 'prawn'

# Draw the competencies for a section. Includes the competence name and a progress bar representing
# your ability with that competency.
class Competence
  include Prawn::View

  def initialize(document, data, theme, available_width)
    @document = document
    @name = data.name
    @value = data.value
    @theme = theme
    @available_width = available_width

    @line_size = @theme.lines[@theme.components.competence.line_size]
    @spacing = @theme.spacing[@theme.components.competence.spacing]
  end

  def default_options(horizontal_cursor)
        {
          document: @document,
          at: [horizontal_cursor, cursor],
          width: @available_width,
          size: @theme.fonts[@theme.components.competence.text_size],
          align: :"#{@theme.components.competence.align}",
          valign: :"#{@theme.components.competence.valign}"
        }
  end

  def name_box(horizontal_cursor)
    text = @name
    options = default_options(horizontal_cursor)
    options[:height] = height_of(text, options)
    box = Prawn::Text::Box.new(text, options)
    box.render(dry_run: true)
    box
  end

  def fit(_horizontal_cursor, remaining_space)
    measure_height < remaining_space
  end

  def measure_height(horizontal_cursor)
    name_box(horizontal_cursor).line_height + @spacing + @line_size
  end

  def write_content(horizontal_cursor)
    fill_color @theme.colors[@theme.components.competence.color]

    left_position = horizontal_cursor
    right_position = horizontal_cursor + @available_width

    self.line_width = @line_size
    self.cap_style = :"#{@theme.components.competence.cap_style}"

    draw_name(horizontal_cursor)
    draw_line(left_position, right_position, line_width)
  end

  def draw_name(horizontal_cursor)
    box = name_box(horizontal_cursor)
    box.render
    move_down box.line_height
    move_down @spacing
  end

  def draw_line(left_position, right_position, line_width)
    y_position = cursor - (line_width / 2)
    draw_background_line(left_position, right_position, y_position)
    draw_foreground_line(left_position, right_position, y_position)
    move_down line_width
  end

  def draw_background_line(left_position, right_position, y_position)
    stroke_color @theme.colors[@theme.components.competence.background_color]
    stroke_horizontal_line left_position, right_position, at: y_position
  end

  def draw_foreground_line(left_position, right_position, y_position)
    stroke_color @theme.colors[@theme.components.competence.filled_color]
    end_position = left_position + ((right_position - left_position) / 10 * @value)
    stroke_horizontal_line left_position, end_position, at: y_position
  end
end
