require 'prawn'

class Competence
    include Prawn::View

    def initialize(document, data, theme, available_width)
        @document = document
        @name = data.name
        @value = data.value
        @theme = theme
        @available_width = available_width

        @line_size = @theme.lines[@theme.components.competence.line_size]
        @spacing = @theme.spacing[@theme.components.competence.spacing]
    end

    def name_box(horizontal_cursor)
        text = @name
        font_size = @theme.fonts[@theme.components.competence.text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            align: :"#{@theme.components.competence.align}",
            valign: :"#{@theme.components.competence.valign}"
        }
        options[:height]= height_of(text, options)
        box = Prawn::Text::Box.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def fit(horizontal_cursor, remaining_space)
        return measure_height() < remaining_space
    end

    def measure_height(horizontal_cursor)
        return name_box(horizontal_cursor).line_height + @spacing + @line_size
    end

    def write_content(horizontal_cursor)
        fill_color @theme.colors[@theme.components.competence.color]

        left_position = horizontal_cursor
        right_position = horizontal_cursor + @available_width

        self.line_width = @line_size
        self.cap_style = :"#{@theme.components.competence.cap_style}"

        box = name_box(horizontal_cursor)
        box.render()
        move_down box.line_height
        move_down @spacing

        stroke_color @theme.colors[@theme.components.competence.background_color]
        stroke_horizontal_line left_position, right_position, at: cursor - self.line_width / 2

        stroke_color @theme.colors[@theme.components.competence.filled_color]
        stroke_horizontal_line left_position, left_position + ((right_position - left_position) / 10 * @value), at: cursor - self.line_width / 2

        move_down self.line_width
    end
end
