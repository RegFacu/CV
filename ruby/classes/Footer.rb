require 'prawn'

class Footer
    include Prawn::View

    def initialize(document, data, theme, available_width)
        @document = document
        @data = data
        @theme = theme
        @available_width = available_width

        @height = @theme.components.footer.height
        @padding = @theme.spacing[@theme.components.footer.padding]
    end

    def full_name_box(horizontal_cursor = 0)
        text = @data.footer.text
        font_size = @theme.fonts[@theme.components.footer.text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            valign: :"#{@theme.components.footer.valign}"
        }
        options[:height]= height_of(text, options)
        box = Prawn::Text::Box.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def measure_height(horizontal_cursor)
        return @height
    end

    def write_content(horizontal_cursor)
        draw_background()

        move_down @padding
        fill_color @theme.colors[@theme.components.footer.color]
        box = full_name_box(@padding)
        box.render()
    end

    def draw_background()
        stops = {
            0 => @theme.colors[@theme.components.footer.start_gradiant_color],
            1 => @theme.colors[@theme.components.footer.end_gradiant_color]
        }
        fill_gradient from: [0, cursor], to: [@available_width, cursor - @height], stops: stops
        fill_rectangle [0, cursor], @available_width, @height
    end
end
