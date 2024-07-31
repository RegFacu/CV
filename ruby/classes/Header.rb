require 'prawn'
require 'prawn-svg'
require 'CustomBox'

class Header
    include Prawn::View

    def initialize(document, data, theme, available_width)
        @document = document
        @data = data
        @theme = theme
        @available_width = available_width

        @height = @theme.components.header.height
        @padding = @theme.spacing[@theme.components.header.padding]
    end

    def full_name_box(horizontal_cursor = 0)
        text = @data.full_name
        font_size = @theme.fonts[@theme.components.header.name_text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            valign: :"#{@theme.components.header.valign}"
        }
        options[:height]= height_of(text, options)
        box = Prawn::Text::Box.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def title_box(horizontal_cursor = 0)
        text = @data.title
        font_size = @theme.fonts[@theme.components.header.title_text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            valign: :"#{@theme.components.header.valign}"
        }
        options[:height]= height_of(text, options)
        box = Prawn::Text::Box.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def phone_box(horizontal_cursor = 0)
        text = @data.phone
        font_size = @theme.fonts[@theme.components.header.contact_text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            valign: :"#{@theme.components.header.valign}"
        }
        options[:height]= height_of(text, options)
        box = CustomBox.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def email_box(horizontal_cursor = 0)
        text = @data.email
        font_size = @theme.fonts[@theme.components.header.contact_text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            valign: :"#{@theme.components.header.valign}"
        }
        options[:height]= height_of(text, options)
        box = CustomBox.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def country_box(horizontal_cursor = 0)
        text = "#{@data.country} (GMT#{@data.time_zone})"
        font_size = @theme.fonts[@theme.components.header.contact_text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            valign: :"#{@theme.components.header.valign}"
        }
        options[:height]= height_of(text, options)
        box = CustomBox.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def write_content(horizontal_cursor)
        draw_background()
        image_size = draw_photo()

        # Maths for dynamic text position
        horizontal_cursor += image_size + @padding * 2 # Move cursor to the right and add spacing after image
        @available_width = @available_width - horizontal_cursor - @padding # Space between the image and the end of the document (without padding)
        name_height = full_name_box().line_height
        title_height = title_box().line_height
        contact_height = phone_box().line_height
        icon_height = contact_height
        total_gap_height = image_size - name_height - title_height - contact_height
        gap_height = total_gap_height / 4 # Gap at top, bottom and between rows (2)

        move_down @padding + gap_height
        line_left_position = horizontal_cursor

        fill_color @theme.colors[@theme.components.header.name_color]
        box = full_name_box(line_left_position)
        box.render()

        move_down box.line_height + gap_height
        line_left_position = horizontal_cursor

        fill_color @theme.colors[@theme.components.header.title_color]
        box = title_box(line_left_position)
        box.render()

        move_down box.line_height + gap_height
        line_left_position = horizontal_cursor

        svg_drawn = draw_icon(@theme.components.header.cell_phone_icon, line_left_position, icon_height)
        line_left_position += svg_drawn[:width]

        box = phone_box(line_left_position)
        box.render()
        line_left_position += box.measured_width + @padding

        svg_drawn = draw_icon(@theme.components.header.email_icon, line_left_position, icon_height)
        line_left_position += svg_drawn[:width]

        box = email_box(line_left_position)
        box.render()
        line_left_position += box.measured_width + @padding

        svg_drawn = draw_icon(@theme.components.header.location_icon, line_left_position, icon_height)
        line_left_position += svg_drawn[:width]

        box = country_box(line_left_position)
        box.render()
        move_down box.line_height + gap_height

        move_cursor_to bounds.height - @height
    end

    def draw_background()
        stops = {
            0 => @theme.colors[@theme.components.header.start_gradiant_color],
            1 => @theme.colors[@theme.components.header.end_gradiant_color]
        }
        fill_gradient from: [0, bounds.height], to: [@available_width, bounds.height - @height], stops: stops
        fill_rectangle [0, bounds.height], @available_width, @height
    end

    def draw_photo()
        image_size = @height - @padding * 2
        image_x = @padding
        image_y = cursor - @padding
        save_graphics_state do
            # Circle image crop
            soft_mask do
                fill_color 0, 0, 0, 0
                fill_circle [image_x + image_size / 2, image_y - image_size/2], image_size/2
            end

            image @data.photo_path, at: [image_x, image_y], width: image_size, height: image_size
        end
        return image_size
    end

    def draw_icon(icon, x, height)
        svg_data = IO.read(icon)
        svg_data = svg_data.gsub! "#000000", "##{@theme.colors[@theme.components.header.icon_color]}"
        saved_cursor = cursor
        svg_drawn = svg svg_data, at: [x, cursor], height: height
        move_cursor_to saved_cursor
        return svg_drawn
    end
end
