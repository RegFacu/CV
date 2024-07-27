require 'prawn'

class Summary
    include Prawn::View

    def initialize(document, data, theme)
        @theme = theme
        @document = document
        @gap = @theme.section.gap
        @left_column = []
        @right_column = []

        data.description.each do |object|
            @left_column << Factory.create_class(Factory::TEXT, @document, object, theme)
        end
        data.competences.each do |object|
            @right_column << Factory.create_class(Factory::COMPETENCE, @document, object, theme)
        end
    end

    def fit(remaining_space)
        left_column_height = 0
        right_column_height = 0
        @left_column.each_with_index do |element, index|
            left_column_height += @gap if index > 0
            left_column_height += element.measure_height()
        end
        @right_column.each_with_index do |element, index|
            right_column_height += @gap if index > 0
            right_column_height += element.measure_height()
        end
        height = [left_column_height, right_column_height].max
        return height < remaining_space
    end

    def write_content()
        saved_cursor = cursor
        @left_column.each_with_index do |element, index|
            move_down @gap if index > 0
            element.write_content()
        end
        move_cursor_to saved_cursor
        @right_column.each_with_index do |element, index|
            move_down @gap if index > 0
            element.write_content()
        end
        move_cursor_to [saved_cursor, cursor].min
    end

    def draw_horizontally(default_options, x, delta_y, height, fill_color, font_size, values)
        fill_color fill_color
        font_size font_size
        left_position = x
        values.each do |value|
            text = value[:text]
            options = default_options.merge({
                at: [left_position, cursor - delta_y],
                height: height,
                available_width: bounds.width - left_position - @gap
            })
            text_box(text, options)
            width = width_of(text, options)

            left_position += width + @gap
        end
        return left_position
    end
end
