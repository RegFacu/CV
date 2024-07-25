require 'prawn'

class Title
    include Prawn::View

    def initialize(document, data, theme)
        @title = data.name
        @theme = theme
        @document = document

        @gap = @theme.section.gap
    end

    def fit(remaining_space)
        return height_of(@title) < remaining_space
    end

    def write_content()
        fill_color @theme.primary_color
        font_size @theme.section.name_text_size

        text_box(@title, {at: [@gap, cursor], width: bounds.width - @gap })
        move_down height_of(@title)
    end
end
