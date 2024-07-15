require 'date'
require 'fileutils'
require 'prawn'
require 'i18n'

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
        write_header()
        @json.content.each do |section|
            write_section(section)
        end
    end

    def write_header()
        header_height = @json.theme.header.height

        # Draw header background color
        stops = {
            0 => @json.theme.header.background_start_gradiant_color,
            1 => @json.theme.header.background_end_gradiant_color
        }
        fill_gradient from: [0, bounds.height], to: [bounds.width, bounds.height - header_height], stops: stops
        fill_rectangle [0, bounds.height], bounds.width, header_height

        # Draw photo image
        header_padding = @json.theme.header.padding
        image_size = header_height - header_padding * 2
        image_x = header_padding
        image_y = bounds.height - header_padding
        save_graphics_state do
            # Circle image crop
            soft_mask do
                fill_color 0,0,0,0
                fill_circle [image_x + image_size/2, image_y - image_size/2], image_size/2
            end

            image @json.personal_info.photo_path, at: [image_x, image_y], width: image_size, height: image_size
        end

        # Text color
        fill_color @json.theme.header.text_color

        left_position = image_size + header_padding * 2
        start_y_position = bounds.height - header_padding

        name_height = image_size / 5
        title_height = image_size / 7
        contact_height = image_size / 12
        gap_height = (image_size - name_height - title_height - contact_height) / 4 # Gap at top, bottom and between rows (2)

        font_size 150 # Ensure we have enough size to make as big as possible
        text_box @json.personal_info.full_name,
            at: [left_position, start_y_position - gap_height],
            width: bounds.width - left_position * 2,
            height: name_height,
            align: :left,
            overflow: :shrink_to_fit
        text_box @json.personal_info.title,
            at: [left_position, start_y_position - gap_height - name_height - gap_height],
            width: bounds.width - left_position * 2,
            height: title_height,
            align: :left,
            overflow: :shrink_to_fit
        text_box "#{@json.personal_info.phone} - #{@json.personal_info.email} - #{@json.personal_info.country} (GMT#{@json.personal_info.time_zone})",
            at: [left_position, start_y_position - gap_height - name_height - gap_height - title_height - gap_height],
            width: bounds.width - left_position * 2,
            height: contact_height,
            align: :left,
            overflow: :shrink_to_fit

        move_cursor_to bounds.height - header_height
        font_size 12
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
