require 'prawn'
require 'prawn-svg'
require 'custom_box'

# Draw a row in the PDF document for the main header of the first page of the document
class Header # rubocop:disable Metrics/ClassLength
  include Prawn::View

  def initialize(document, data, theme, available_width)
    @document = document
    @data = data
    @theme = theme
    @available_width = available_width

    @height = @theme.components.header.height
    @padding = @theme.spacing[@theme.components.header.padding]
  end

  def default_options(horizontal_cursor, font_size)
    return {
      document: @document,
      at: [horizontal_cursor, cursor],
      width: @available_width,
      size: font_size,
      align: :"#{@theme.components.header.align}",
      valign: :"#{@theme.components.header.valign}"
    }
  end

  def full_name_box(horizontal_cursor = 0)
    text = @data.full_name
    options = default_options(horizontal_cursor, @theme.fonts[@theme.components.header.name_text_size])
    options[:height] = height_of(text, options)
    box = Prawn::Text::Box.new(text, options)
    box.render(dry_run: true)
    box
  end

  def title_box(horizontal_cursor = 0)
    text = @data.title
    options = default_options(horizontal_cursor, @theme.fonts[@theme.components.header.title_text_size])
    options[:height] = height_of(text, options)
    box = Prawn::Text::Box.new(text, options)
    box.render(dry_run: true)
    box
  end

  def phone_box(horizontal_cursor = 0)
    text = @data.phone
    options = default_options(horizontal_cursor, @theme.fonts[@theme.components.header.contact_text_size])
    options[:height] = height_of(text, options)
    box = CustomBox.new(text, options)
    box.render(dry_run: true)
    box
  end

  def email_box(horizontal_cursor = 0)
    text = @data.email
    options = default_options(horizontal_cursor, @theme.fonts[@theme.components.header.contact_text_size])
    options[:height] = height_of(text, options)
    box = CustomBox.new(text, options)
    box.render(dry_run: true)
    box
  end

  def country_box(horizontal_cursor = 0)
    text = "#{@data.country} (GMT#{@data.time_zone})"
    options = default_options(horizontal_cursor, @theme.fonts[@theme.components.header.contact_text_size])
    options[:height] = height_of(text, options)
    box = CustomBox.new(text, options)
    box.render(dry_run: true)
    box
  end

  def text_position(horizontal_cursor, image_size)
    # ----- Maths for dynamic text position -----
    # Space between the image and the end of the document (without padding)
    @available_width = @available_width - horizontal_cursor - @padding

    name_height = full_name_box.line_height
    title_height = title_box.line_height
    contact_height = phone_box.line_height
    total_gap_height = image_size - name_height - title_height - contact_height
    {
      icon_height: contact_height,
      gap_height: total_gap_height / 4 # Gap at top, bottom and between rows (2)
    }
  end

  def draw_name(horizontal_cursor, gap_height)
    line_left_position = horizontal_cursor
    fill_color @theme.colors[@theme.components.header.name_color]
    box = full_name_box(line_left_position)
    box.render
    move_down box.line_height + gap_height
  end

  def draw_title(horizontal_cursor, gap_height)
    line_left_position = horizontal_cursor
    fill_color @theme.colors[@theme.components.header.title_color]
    box = title_box(line_left_position)
    box.render
    move_down box.line_height + gap_height
  end

  def draw_contact(horizontal_cursor, gap_height, height)
    line_left_position = horizontal_cursor

    width = draw_phone(line_left_position, height)
    line_left_position += width + @padding

    width = draw_email(line_left_position, height)
    line_left_position += width + @padding

    draw_country(line_left_position, height)

    move_down height + gap_height
  end

  def draw_phone(line_left_position, icon_height)
    svg_drawn = draw_icon(@theme.components.header.cell_phone_icon, line_left_position, icon_height)
    line_left_position += svg_drawn[:width]

    box = phone_box(line_left_position)
    box.render
    box.measured_width + svg_drawn[:width]
  end

  def draw_email(line_left_position, icon_height)
    svg_drawn = draw_icon(@theme.components.header.email_icon, line_left_position, icon_height)
    line_left_position += svg_drawn[:width]

    box = email_box(line_left_position)
    box.render
    box.measured_width + svg_drawn[:width]
  end

  def draw_country(line_left_position, icon_height)
    svg_drawn = draw_icon(@theme.components.header.location_icon, line_left_position, icon_height)
    line_left_position += svg_drawn[:width]

    box = country_box(line_left_position)
    box.render
    box.measured_width + svg_drawn[:width]
  end

  def write_content(horizontal_cursor)
    draw_background
    image_size = draw_photo

    horizontal_cursor += image_size + (@padding * 2) # Move cursor to the right and add spacing after image
    draw_text(horizontal_cursor, image_size)

    move_cursor_to bounds.height - @height
  end

  def draw_text(horizontal_cursor, image_size)
    text_position = text_position(horizontal_cursor, image_size)

    move_down @padding + text_position[:gap_height]
    draw_name(horizontal_cursor, text_position[:gap_height])
    draw_title(horizontal_cursor, text_position[:gap_height])
    draw_contact(horizontal_cursor, text_position[:gap_height], text_position[:icon_height])
  end

  def draw_background
    fill_gradient(from: [0, bounds.height], to: [@available_width, bounds.height - @height], stops:)
    fill_rectangle [0, bounds.height], @available_width, @height
  end

  def stops
    {
      0 => @theme.colors[@theme.components.header.start_gradiant_color],
      1 => @theme.colors[@theme.components.header.end_gradiant_color]
    }
  end

  def draw_photo
    image_size = @height - (@padding * 2)
    image_x = @padding
    image_y = cursor - @padding
    save_graphics_state do
      circle_image_crop(image_x, image_y, image_size)
      image @data.photo_path, at: [image_x, image_y], width: image_size, height: image_size
    end
    image_size
  end

  def circle_image_crop(image_x, image_y, image_size)
    soft_mask do
      fill_color 0, 0, 0, 0
      fill_circle [image_x + (image_size / 2), image_y - (image_size / 2)], image_size / 2
    end
  end

  def draw_icon(icon, x_position, height)
    svg_data = File.read(icon)
    svg_data = svg_data.gsub! '#000000', "##{@theme.colors[@theme.components.header.icon_color]}"
    saved_cursor = cursor
    svg_drawn = svg(svg_data, at: [x_position, cursor], height:)
    move_cursor_to saved_cursor
    svg_drawn
  end
end
