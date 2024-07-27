require 'prawn'

class Competence
    include Prawn::View

    def initialize(document, data, theme)
        @name = data.name
        @value = data.value
        @theme = theme
        @document = document

        @gap = @theme.section.gap
    end

    def fit(remaining_space)
        return measure_height() < remaining_space
    end

    def measure_height()
        return height_of(@name) + 6
    end

    def write_content()
        fill_color @theme.default_color
        font_size @theme.section.small_text_size

        left_position = 400
        right_position = bounds.width - @gap

        self.line_width = 6
        competence_width = 100

        self.cap_style = :round
        size = text_box(@name, {at: [left_position, cursor]})
        move_down height_of(@name)

        stroke_color @theme.secondary_color
        stroke_horizontal_line left_position, right_position, at: cursor - self.line_width / 2

        stroke_color @theme.primary_color
        stroke_horizontal_line left_position, left_position + ((right_position - left_position) / 10 * @value), at: cursor - self.line_width / 2

        move_down self.line_width
    end
end
