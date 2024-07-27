require 'CustomBox'

class Job < Summary
    def initialize(document, data, theme, available_width)
        super
        @title = data.title
        @company = data.company
        @from = data.from
        @to = data.to
    end

    def title_box(horizontal_cursor = 0, height = nil)
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            height: height || height_of(@title, {size: @theme.section.name_text_size}),
            size: @theme.section.name_text_size,
            valign: :center
        }
        box = CustomBox.new(@title, options)
        box.render(:dry_run => true)
        return box
    end

    def company_box(horizontal_cursor = 0, height = nil)
        options = {
            document: @document,
            at: [horizontal_cursor, cursor],
            width: @available_width,
            height: height || height_of(@title, {size: @theme.section.company_text_size}),
            size: @theme.section.company_text_size,
            valign: :center
        }
        box = CustomBox.new("#{@company} - #{@from} - #{@to}", options)
        box.render(:dry_run => true)
        return box
    end

    def fit(horizontal_cursor, remaining_space)
        @job_height = [title_box(horizontal_cursor).height, company_box(horizontal_cursor).height].max
        return @job_height + @theme.section.title_spacing + measure_height(horizontal_cursor) < remaining_space
    end

    def write_content(horizontal_cursor)
        fill_color @theme.secondary_color
        title_box = title_box(horizontal_cursor, @job_height)
        title_box.render()

        space_between_text = @gap

        fill_color @theme.default_color
        company_box = company_box(horizontal_cursor + title_box.measured_width + space_between_text, @job_height)
        company_box.render()

        move_down [title_box.height, company_box.height].max
        move_down @theme.section.title_spacing
        super
    end
end
