require 'prawn'

class Competence
    include Prawn::View

    def initialize(document, data, theme, available_width)
        @document = document
        @name = data.name
        @value = data.value
        @theme = theme
        @available_width = available_width
    end

    def name_box(horizontal_cursor)
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            height: height_of(@name, {size: @theme.section.small_text_size}),
            size: @theme.section.small_text_size,
            valign: :center
        }
        box = Prawn::Text::Box.new(@name, options)
        box.render(:dry_run => true)
        return box
    end

    def fit(horizontal_cursor, remaining_space)
        return measure_height() < remaining_space
    end

    def measure_height(horizontal_cursor)
        return name_box(horizontal_cursor).height + @theme.competence_spacing + @theme.competence_line_size
    end

    def write_content(horizontal_cursor)
        fill_color @theme.default_color
        font_size @theme.section.small_text_size

        left_position = horizontal_cursor
        right_position = horizontal_cursor + @available_width

        self.line_width = @theme.competence_line_size

        self.cap_style = :round
        box = name_box(horizontal_cursor)
        box.render()
        move_down box.height
        move_down @theme.competence_spacing

        stroke_color @theme.secondary_color
        stroke_horizontal_line left_position, right_position, at: cursor - self.line_width / 2

        stroke_color @theme.primary_color
        stroke_horizontal_line left_position, left_position + ((right_position - left_position) / 10 * @value), at: cursor - self.line_width / 2

        move_down self.line_width
    end
end
