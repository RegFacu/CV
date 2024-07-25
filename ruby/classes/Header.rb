require 'prawn'
require 'prawn-svg'

class Header
    include Prawn::View

    def initialize(document, data, theme)
        @data = data
        @theme = theme
        @document = document

        @height = @theme.height
        @padding = @theme.padding
    end

    def write_content()
        draw_background()
        image_size = draw_photo()

        # Maths for dynamic text position
        left_position = image_size + @padding * 2
        available_width = bounds.width - left_position - @padding # Space between the image and the end of the document
        default_options = {
            document: @document,
            width: available_width,
            valign: :center
        }
        name_height = height_of(@data.full_name, default_options.merge({size: @theme.name_font_size}))
        title_height = height_of(@data.title, default_options.merge({size: @theme.title_font_size}))
        contact_height = height_of(@data.phone, default_options.merge({size: @theme.contact_font_size}))
        total_gap_height = image_size - name_height - title_height - contact_height
        gap_height = total_gap_height / 4 # Gap at top, bottom and between rows (2)

        move_down @padding
        draw_horizontally(
            default_options,
            left_position,
            gap_height,
            name_height,
            @theme.primary_text_color,
            @theme.name_font_size,
            [{text: @data.full_name}])
        draw_horizontally(
            default_options,
            left_position,
            gap_height,
            title_height,
            @theme.secondary_text_color,
            @theme.title_font_size,
            [{text: @data.title}])
        draw_horizontally(
            default_options,
            left_position,
            gap_height,
            contact_height,
            @theme.secondary_text_color,
            @theme.contact_font_size,
            [
                {text: @data.phone},
                {text: @data.email},
                {text: "#{@data.country} (GMT#{@data.time_zone})"}
            ])

        move_cursor_to bounds.height - @height
    end

    def draw_background()
        stops = {
            0 => @theme.background_start_gradiant_color,
            1 => @theme.background_end_gradiant_color
        }
        fill_gradient from: [0, bounds.height], to: [bounds.width, bounds.height - @height], stops: stops
        fill_rectangle [0, bounds.height], bounds.width, @height
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

    def draw_horizontally(default_options, x, delta_y, height, fill_color, font_size, values)
        fill_color fill_color
        font_size font_size
        max_height = 0
        left_position = x
        values.each do |value|
            text = value[:text]
            options = default_options.merge({
                at: [left_position, cursor - delta_y],
                height: height,
                available_width: bounds.width - left_position - @padding
            })
            text_box(text, options)
            width = width_of(text, options)
            height = height_of(text, options)

            left_position += width + @padding
            max_height = [max_height, height].max
        end
        move_down delta_y + max_height
    end
end
