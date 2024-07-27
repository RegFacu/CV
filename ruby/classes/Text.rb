require 'prawn'

class Text
    include Prawn::View

    def initialize(document, data, theme)
        @text = data.text
        @bullet = data.bullet
        @theme = theme
        @document = document

        @gap = @theme.section.gap
    end

    def fit(remaining_space)
        return measure_height() < remaining_space
    end

    def measure_height()
        return height_of(@text)
    end

    def write_content()
        fill_color @theme.default_color
        font_size @theme.section.default_text_size

        left = @gap
        available_width = @theme.column_width
        if @bullet != nil
            bullet_size = @theme.bullet_size
            fill_ellipse [left + bullet_size, cursor - bullet_size * 1.5], bullet_size
            left += bullet_size * 2 + @gap / 2
            available_width -= bullet_size * 2 + @gap / 2
        end
        options = {at: [left, cursor], width: available_width - @gap }
        text_box(@text, options)
        move_down(height_of(@text, options))
    end
end
