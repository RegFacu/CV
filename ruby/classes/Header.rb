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

        @height = @theme.height
        @padding = @theme.padding
    end

    def full_name_box(horizontal_cursor = 0)
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            height: height_of(@data.full_name, {size: @theme.name_font_size}),
            size: @theme.name_font_size,
            valign: :center
        }
        box = Prawn::Text::Box.new(@data.full_name, options)
        box.render(:dry_run => true)
        return box
    end

    def title_box(horizontal_cursor = 0)
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            height: height_of(@data.title, {size: @theme.title_font_size}),
            size: @theme.title_font_size,
            valign: :center
        }
        box = Prawn::Text::Box.new(@data.title, options)
        box.render(:dry_run => true)
        return box
    end

    def phone_box(horizontal_cursor = 0)
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            height: height_of(@data.phone, {size: @theme.contact_font_size}),
            size: @theme.contact_font_size,
            valign: :center
        }
        box = CustomBox.new(@data.phone, options)
        box.render(:dry_run => true)
        return box
    end

    def email_box(horizontal_cursor = 0)
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            height: height_of(@data.email, {size: @theme.contact_font_size}),
            size: @theme.contact_font_size,
            valign: :center
        }
        box = CustomBox.new(@data.email, options)
        box.render(:dry_run => true)
        return box
    end

    def country_box(horizontal_cursor = 0)
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            height: height_of("#{@data.country} (GMT#{@data.time_zone})", {size: @theme.contact_font_size}),
            size: @theme.contact_font_size,
            valign: :center
        }
        box = CustomBox.new("#{@data.country} (GMT#{@data.time_zone})", options)
        box.render(:dry_run => true)
        return box
    end

    def write_content(horizontal_cursor)
        draw_background()
        image_size = draw_photo()

        # Maths for dynamic text position
        horizontal_cursor += image_size + @padding * 2
        @available_width = @available_width - horizontal_cursor - @padding # Space between the image and the end of the document
        name_height = full_name_box().line_height
        title_height = title_box().line_height
        contact_height = phone_box().line_height
        icon_height = contact_height
        total_gap_height = image_size - name_height - title_height - contact_height
        gap_height = total_gap_height / 4 # Gap at top, bottom and between rows (2)

        move_down @padding + gap_height

        fill_color @theme.primary_color
        box = full_name_box(horizontal_cursor)
        box.render()

        move_down box.line_height + gap_height

        fill_color @theme.secondary_text_color
        box = title_box(horizontal_cursor)
        box.render()

        move_down box.line_height + gap_height

        left_position = horizontal_cursor
        descender = 0

        svg_drawn = draw_icon(@theme.cell_phone_icon, left_position, icon_height)
        left_position += svg_drawn[:width]

        box = phone_box(left_position)
        box.render()
        left_position += box.measured_width + @padding

        svg_drawn = draw_icon(@theme.email_icon, left_position, icon_height)
        left_position += svg_drawn[:width]

        box = email_box(left_position)
        box.render()
        left_position += box.measured_width + @padding

        svg_drawn = draw_icon(@theme.location_icon, left_position, icon_height)
        left_position += svg_drawn[:width]

        box = country_box(left_position)
        box.render()
        move_down box.line_height + gap_height

        move_cursor_to bounds.height - @height
    end

    def draw_background()
        stops = {
            0 => @theme.background_start_gradiant_color,
            1 => @theme.background_end_gradiant_color
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
        svg_data = svg_data.gsub! "#000000", "##{@theme.primary_color}"
        saved_cursor = cursor
        svg_drawn = svg svg_data, at: [x, cursor], height: height
        move_cursor_to saved_cursor
        return svg_drawn
    end
end
