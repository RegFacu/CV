require 'prawn'

# Draw text for a section. The text could be represented as a bullet.
class Text
  include Prawn::View

  def initialize(document, data, theme, available_width)
    @document = document
    @text = data.text
    @bullet = data.bullet
    @theme = theme
    @available_width = available_width
    @bullet_radius = @theme.components.text.bullet_radius
    @bullet_gap = @theme.spacing[@theme.components.text.bullet_spacing]
  end

  def default_options(horizontal_cursor, available_width)
    {
      document: @document,
      at: [horizontal_cursor, cursor],
      width: available_width,
      size: @theme.fonts[@theme.components.text.text_size],
      align: :"#{@theme.components.text.align}",
      valign: :"#{@theme.components.text.valign}"
    }
  end

  def text_box(horizontal_cursor = 0)
    available_width = @available_width

    text = @text
    options = default_options(horizontal_cursor + bullet_width(available_width),
                              available_width - bullet_width(available_width))
    options[:height] = height_of(text, options)
    box = Prawn::Text::Box.new(text, options)
    box.render(dry_run: true)
    box
  end

  def bullet_width(available_width)
    bullet_width = 0
    if !@bullet.nil? && @bullet
      bullet_width = (@bullet_radius * 2) + @bullet_gap
      available_width - bullet_width
    end
    bullet_width
  end

  def fit(horizontal_cursor, remaining_space)
    measure_height(horizontal_cursor) < remaining_space
  end

  def measure_height(horizontal_cursor)
    text_box(horizontal_cursor).height
  end

  def write_content(horizontal_cursor)
    box = text_box(horizontal_cursor)
    write_bullet(horizontal_cursor, box) unless @bullet.nil?

    fill_color @theme.colors[@theme.components.text.color]
    box.render
    move_down box.height
  end

  def write_bullet(horizontal_cursor, box)
    fill_color @theme.colors[@theme.components.text.bullet_color]
    fill_ellipse [horizontal_cursor + @bullet_radius, cursor - (box.line_height / 2)], @bullet_radius
  end
end
