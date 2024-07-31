require 'prawn'

class Spacing
    include Prawn::View

    def initialize(document, data, theme, available_width)
        @document = document
        @theme = theme
        @available_width = available_width
        @spacing = @theme.spacing[data.spacing]
    end

    def fit(horizontal_cursor, remaining_space)
        return @spacing < remaining_space
    end

    def write_content(horizontal_cursor)
        move_down @spacing
    end
end
