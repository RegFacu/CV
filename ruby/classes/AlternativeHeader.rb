require 'prawn'

class AlternativeHeader
    include Prawn::View

    def initialize(document, data, theme, available_width)
        @document = document
        @data = data
        @theme = theme
        @available_width = available_width

        @height = @theme.components.alternative_header.height
        @padding = @theme.spacing[@theme.components.alternative_header.padding]
    end

    def full_name_box(horizontal_cursor = 0)
        text = @data.full_name
        font_size = @theme.fonts[@theme.components.alternative_header.text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            align: :"#{@theme.components.alternative_header.align}",
            valign: :"#{@theme.components.alternative_header.valign}"
        }
        options[:height]= @height - @padding * 2
        box = Prawn::Text::Box.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def write_content(horizontal_cursor)
        draw_background()

        image_size = draw_photo()
        horizontal_cursor += image_size + @padding * 2 # Move cursor to the right and add spacing after image

        move_down @padding
        fill_color @theme.colors[@theme.components.alternative_header.color]
        box = full_name_box(horizontal_cursor)
        box.render()

        move_cursor_to bounds.height - @height
    end

    def draw_background()
        stops = {
            0 => @theme.colors[@theme.components.alternative_header.start_gradiant_color],
            1 => @theme.colors[@theme.components.alternative_header.end_gradiant_color]
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
end
