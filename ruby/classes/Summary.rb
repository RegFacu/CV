require 'prawn'

class Summary
    include Prawn::View

    def initialize(document, data, theme, available_width)
        @document = document
        @theme = theme
        @available_width = available_width
        @space_between_columns = @theme.spacing[@theme.components.summary.space_between_columns]
        @space_between_rows = @theme.spacing[@theme.components.summary.space_between_rows]
        @left_column = []
        @right_column = []

        @left_column_width = @theme.components.summary.left_column_width
        @right_column_width = available_width - @left_column_width - @space_between_columns
        data.description.each do |object|
            @left_column << Factory.create_class(Factory::TEXT, @document, object, theme, @left_column_width)
        end
        data.competences.each do |object|
            @right_column << Factory.create_class(Factory::COMPETENCE, @document, object, theme, @right_column_width)
        end
    end

    def fit(horizontal_cursor, remaining_space)
        return measure_height(horizontal_cursor) < remaining_space
    end

    def measure_height(horizontal_cursor)
        left_column_height = 0
        right_column_height = 0
        @left_column.each_with_index do |element, index|
            left_column_height += @space_between_rows if index > 0
            left_column_height += element.measure_height(horizontal_cursor)
        end
        @right_column.each_with_index do |element, index|
            right_column_height += @space_between_rows if index > 0
            right_column_height += element.measure_height(horizontal_cursor)
        end
        return [left_column_height, right_column_height].max
    end

    def write_content(horizontal_cursor)
        saved_cursor = cursor
        @left_column.each_with_index do |element, index|
            move_down @space_between_rows if index > 0
            element.write_content(horizontal_cursor)
        end
        move_cursor_to saved_cursor
        @right_column.each_with_index do |element, index|
            move_down @space_between_rows if index > 0
            element.write_content(horizontal_cursor + @left_column_width + @space_between_columns)
        end
        move_cursor_to [saved_cursor, cursor].min
    end
end
