require 'prawn'

class Title
    include Prawn::View

    def initialize(document, data, theme, available_width)
        @document = document
        @name = data.name
        @theme = theme
        @available_width = available_width
        @spacing = @theme.spacing[@theme.components.title.spacing]
    end

    def name_box(horizontal_cursor = 0)
        text = @name
        font_size = @theme.fonts[@theme.components.title.text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            valign: :"#{@theme.components.title.valign}"
        }
        options[:height]= height_of(text, options)
        box = Prawn::Text::Box.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def fit(horizontal_cursor, remaining_space)
        return name_box(horizontal_cursor).height + @spacing < remaining_space
    end

    def write_content(horizontal_cursor)
        fill_color @theme.colors[@theme.components.title.color]

        box = name_box(horizontal_cursor)
        box.render()
        move_down box.height + @spacing
    end
end
