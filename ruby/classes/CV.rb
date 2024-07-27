require 'date'
require 'fileutils'
require 'prawn'

require 'Factory'

class CV
    include Prawn::View

    def initialize(json)
        @json = json
        @theme = json.theme
        @gap = @theme.spacing[@theme.space_between_components]
        @padding = @theme.spacing[@theme.padding]
        font json.theme.default_font
        draw_background_color()
    end

    def document
        @document ||= Prawn::Document.new(page_size: 'A4', margin: 0)
    end

    def draw_background_color()
        fill_color @json.theme.colors[@json.theme.background_color]
        fill_rectangle [0, bounds.height], bounds.width, bounds.height
    end

    def write_content()
        available_width = bounds.width # Full available width for header
        Factory.create_class(Factory::HEADER, @document, @json.data.header, @json.theme, available_width).write_content(0)

        available_width = bounds.width - @padding * 2 # Left and right padding for content
        move_down(@padding) # Top padding
        @json.data.sections.each do |section|
            clazz = Factory.create_class(section.type, document, section, @json.theme, available_width)
            horizontal_cursor = @padding
            remaining_space = cursor - @padding # Bottom padding
            if ! clazz.fit(horizontal_cursor, remaining_space)
                start_new_page
                move_down(@padding) # Top padding for new page
            end

            clazz.write_content(horizontal_cursor)
            move_down(@gap)
        end
    end

    def export(export_dir_path, language)
        FileUtils.mkdir_p(export_dir_path) unless File.directory?(export_dir_path)
        save_as(File.join(export_dir_path, "cv_#{language}.pdf"))
    end
end
