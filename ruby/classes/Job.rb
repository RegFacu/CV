require 'CustomBox'

class Job < Summary
    def initialize(document, data, theme, available_width)
        super
        @title = data.title
        @company = data.company
        @from = data.from
        @to = data.to
        @title_spacing = @theme.spacing[@theme.components.job.title_spacing]
        @space_between_texts = @theme.spacing[@theme.components.job.space_between_texts]
    end

    def title_box(horizontal_cursor = 0, height = nil)
        text = @title
        font_size = @theme.fonts[@theme.components.job.title_text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            valign: :"#{@theme.components.job.valign}"
        }
        options[:height]= height || height_of(text, options)
        box = CustomBox.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def company_box(horizontal_cursor = 0, height = nil)
        text = "#{@company} - #{@from} - #{@to}"
        font_size = @theme.fonts[@theme.components.job.company_text_size]
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            size: font_size,
            valign: :"#{@theme.components.job.valign}"
        }
        options[:height]= height || height_of(text, options)
        box = CustomBox.new(text, options)
        box.render(:dry_run => true)
        return box
    end

    def fit(horizontal_cursor, remaining_space)
        @job_height = [title_box(horizontal_cursor).line_height, company_box(horizontal_cursor).line_height].max
        return @job_height + @title_spacing + measure_height(horizontal_cursor) < remaining_space
    end

    def write_content(horizontal_cursor)
        fill_color @theme.colors[@theme.components.job.title_color]
        title_box = title_box(horizontal_cursor, @job_height)
        title_box.render()

        fill_color @theme.colors[@theme.components.job.company_color]
        company_box = company_box(horizontal_cursor + title_box.measured_width + @space_between_texts, @job_height)
        company_box.render()

        move_down [title_box.line_height, company_box.line_height].max
        move_down @title_spacing
        super
    end
end
