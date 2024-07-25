require 'date'
require 'fileutils'
require 'prawn'

require 'Factory'

class CV
    include Prawn::View

    def initialize(json)
        @json = json
        draw_background_color()
    end

    def document
        @document ||= Prawn::Document.new(page_size: 'A4', margin: 0)
    end

    def draw_background_color()
        fill_color @json.theme.background_color
        fill_rectangle [0, bounds.height], bounds.width, bounds.height
    end

    def write_content()
        Factory.create_class(Factory::HEADER, @document, @json.data.header, @json.theme.header).write_content()
        @json.data.sections.each do |section|
            write_section(section)
        end
    end

    def custom_text_box(text, options, move_down = true)
        options[:document] = @document
        text_box(text, options)
        measure = Prawn::Text::Box.new(text, options)
        measure.render(:dry_run => true)
        move_down(measure.height) if move_down
        width = width_of(text, size: options[:font_size])
        return { "width": width, "height": measure.height}
    end

    def write_section(section)
        gap = @json.theme.section.gap
        move_down(gap)
        if section.name
            fill_color @json.theme.primary_color
            font_size @json.theme.section.name_text_size
            custom_text_box(section.name, {at: [gap, cursor], width: bounds.width / 2 - gap })
        end
        if section.title
            fill_color @json.theme.secondary_color
            font_size @json.theme.section.title_text_size
            size = custom_text_box(section.title, {at: [gap, cursor], width: bounds.width / 2 - gap })

            fill_color @json.theme.default_color
            font_size @json.theme.section.default_text_size
            custom_text_box("#{section.company} - #{section.from} - #{section.to}", {at: [gap + size[:width] + gap, cursor + size[:height]]}, false)
        end
        competence_cursor = cursor
        column_width = bounds.width * 0.6
        if section.description
            move_down(gap)
            fill_color @json.theme.default_color
            font_size @json.theme.section.default_text_size
            section.description.each do |description|
                left = gap
                if description.bullet
                    bullet_size = 4
                    fill_ellipse [left + bullet_size, cursor - bullet_size * 1.5], bullet_size
                    left += bullet_size * 2 + gap / 2
                end
                custom_text_box(description.text, {at: [left, cursor], width: column_width - gap })
                move_down(gap / 2)
            end
        end
        end_cursor = cursor
        if section.competences
            move_cursor_to competence_cursor
            fill_color @json.theme.default_color
            font_size @json.theme.section.small_text_size

            self.line_width = 6
            competence_width = 0
            section.competences.each do |competence|
                competence_width = [competence_width, width_of(competence.name, size: font_size)].max
            end
            section.competences.each do |competence|
                self.cap_style = :round
                left_position = gap + column_width
                size = custom_text_box(competence.name, {at: [left_position, cursor]})

                left_position = left_position + competence_width + gap
                right_position = bounds.width - gap

                stroke_color @json.theme.secondary_color
                stroke_horizontal_line left_position, right_position, at: cursor + size[:height] - self.line_width / 2

                stroke_color @json.theme.primary_color
                stroke_horizontal_line left_position, left_position + ((right_position - left_position) / 10 * competence.value), at: cursor + size[:height] - self.line_width / 2

            end
        end
        self.cap_style = :butt
        move_cursor_to end_cursor
        start_new_page if cursor < (bounds.height * 0.2)
    end

    def export(export_dir_path, language)
        FileUtils.mkdir_p(export_dir_path) unless File.directory?(export_dir_path)
        save_as(File.join(export_dir_path, "cv_#{language}.pdf"))
    end
end
