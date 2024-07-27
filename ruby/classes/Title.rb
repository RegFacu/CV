require 'prawn'

class Title
    include Prawn::View

    def initialize(document, data, theme, available_width)
        @document = document
        @name = data.name
        @theme = theme
        @available_width = available_width
    end

    def name_box(horizontal_cursor = 0)
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            height: height_of(@name, {size: @theme.section.title_text_size}),
            size: @theme.section.title_text_size,
            valign: :center
        }
        box = Prawn::Text::Box.new(@name, options)
        box.render(:dry_run => true)
        return box
    end

    def fit(horizontal_cursor, remaining_space)
        return name_box(horizontal_cursor).height < remaining_space
    end

    def write_content(horizontal_cursor)
        fill_color @theme.primary_color

        box = name_box(horizontal_cursor)
        box.render()
        move_down box.height
    end
end
