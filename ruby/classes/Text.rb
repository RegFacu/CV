require 'prawn'

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

    def text_box(horizontal_cursor = 0)
        available_width = @available_width
        bullet_width = 0
        if @bullet != nil && @bullet
            bullet_width = @bullet_radius * 2 + @bullet_gap
            available_width = available_width - bullet_width
        end

        text = @text
        font_size = @theme.fonts[@theme.components.text.text_size]
        options = {
            document: @document,
            at: [horizontal_cursor + bullet_width, cursor],
            width: available_width,
            size: font_size,
            align: :"#{@theme.components.text.align}",
            valign: :"#{@theme.components.text.valign}"
        }
        options[:height]= height_of(text, options)
        box = Prawn::Text::Box.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def fit(horizontal_cursor, remaining_space)
        return measure_height(horizontal_cursor) < remaining_space
    end

    def measure_height(horizontal_cursor)
        return text_box(horizontal_cursor).height
    end

    def write_content(horizontal_cursor)
        box = text_box(horizontal_cursor)
        if @bullet != nil
            fill_color @theme.colors[@theme.components.text.bullet_color]
            fill_ellipse [horizontal_cursor + @bullet_radius, cursor  - box.line_height / 2], @bullet_radius
        end

        fill_color @theme.colors[@theme.components.text.color]
        box.render()
        move_down box.height
    end
end
