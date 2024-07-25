require 'prawn'

class Job
    include Prawn::View

    def initialize(document, data, theme)
        @title = data.title
        @company = data.company
        @from = data.from
        @to = data.to
        @theme = theme
        @document = document
        @left_column = []
        data.description.each do |object|
            @left_column << Factory.create_class(Factory::TEXT, @document, object, theme)
        end
        @right_column = []
        data.competences.each do |object|
            @right_column << Factory.create_class(Factory::COMPETENCE, @document, object, theme)
        end

        @gap = @theme.section.gap
    end

    def fit(remaining_space)
        return height_of(@title) < remaining_space
    end

    def write_content()
        left_position = @gap
        available_width = bounds.width - left_position - @gap # Space between the image and the end of the document
        default_options = {
            document: @document,
            width: available_width,
            valign: :center
        }
        title_height = height_of(@title, default_options.merge({size: @theme.name_font_size}))
        company_height = height_of(@company, default_options.merge({size: @theme.title_font_size}))
        height = [title_height, company_height].max

        left_position += @gap + draw_horizontally(
            default_options,
            left_position,
            0,
            height,
            @theme.secondary_color,
            @theme.section.title_text_size,
            [{text: @title}])

        draw_horizontally(
            default_options,
            left_position,
            0,
            height,
            @theme.default_color,
            @theme.section.default_text_size,
            [
                {text: @company},
                {text: "-"},
                {text: @from},
                {text: "-"},
                {text: @to}
            ])

        @left_column.each do |element|
            element.write_content()
        end
        @right_column.each do |element|
            element.write_content()
        end
        move_down height
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
