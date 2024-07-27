require 'prawn'

class Text
    include Prawn::View

    def initialize(document, data, theme, available_width)
        @document = document
        @text = data.text
        @bullet = data.bullet
        @theme = theme
        @available_width = available_width
        @bullet_radius = @theme.bullet_radius
        @bullet_gap = @theme.section.gap
    end

    def text_box(horizontal_cursor = 0)
        available_width = @available_width
        bullet_width = 0
        if @bullet != nil && @bullet
            bullet_width = @bullet_radius * 2 + @bullet_gap
            available_width = available_width - bullet_width
        end
        options = {
            document: @document,
            at: [horizontal_cursor + bullet_width, cursor],
            width: available_width,
            height: height_of(@text, {size: @theme.section.default_text_size}),
            size: @theme.section.default_text_size,
            valign: :center
        }
        box = Prawn::Text::Box.new(@text, options)
        box.render(:dry_run => true)
        return box
    end

    def fit(horizontal_cursor, remaining_space)
        return measure_height(horizontal_cursor) < remaining_space
    end

    def measure_height(horizontal_cursor)
        return text_box(horizontal_cursor).height
    end

    def write_content(horizontal_cursor)
        fill_color @theme.default_color

        if @bullet != nil
            fill_ellipse [horizontal_cursor + @bullet_radius, cursor - @bullet_radius * 2], @bullet_radius
        end

        box = text_box(horizontal_cursor)
        box.render()
        move_down box.height
    end
end
