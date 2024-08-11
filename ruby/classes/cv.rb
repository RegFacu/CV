require 'date'
require 'fileutils'
require 'prawn'

require 'factory'

# Generate the PDF, draw the background, configure some elements of the document like font and new pages definitions
# and draw each section of the data to be generated
class CV
  include Prawn::View

  def initialize(data)
    @data = data
    @theme = data.theme
    @space_between_components = @theme.spacing[@theme.space_between_components]
    @padding = @theme.spacing[@theme.padding]
    draw_background_color
    assign_font(data.theme.default_font)
  end

  def document
    @document ||= Prawn::Document.new(page_size: 'A4', margin: 0)
  end

  def assign_font(font)
    absolute_path = File.expand_path('../../assets/font', __dir__)
    font_families.update(font => {
                           normal: "#{absolute_path}/#{font}_normal.ttf",
                           italic: "#{absolute_path}/#{font}_italic.ttf",
                           bold: "#{absolute_path}/#{font}_bold.ttf",
                           bold_italic: "#{absolute_path}/#{font}_bold_italic.ttf"
                         })
    font font
  end

  def draw_background_color
    fill_color @data.theme.colors[@data.theme.background_color]
    fill_rectangle [0, bounds.height], bounds.width, bounds.height
  end

  def write_content
    full_width = bounds.width # Full available width for header and footer
    Factory.create_class(
      Factory::HEADER,
      @document,
      @data.data.header,
      @data.theme,
      full_width
    ).write_content(0)
    move_down(@padding) # Top padding
    write_sections(@data.data.sections, available_width, footer(full_width), alternative_header(full_width))
  end

  def available_width
    bounds.width - (@padding * 2) # Left and right padding for content
  end

  def footer(available_width)
    Factory.create_class(Factory::FOOTER, @document, @data.data, @data.theme, available_width)
  end

  def alternative_header(available_width)
    Factory.create_class(Factory::ALTERNATIVE_HEADER, @document, @data.data.header, @data.theme, available_width)
  end

  def write_sections(sections, available_width, footer, alternative_header)
    sections.each do |section|
      write_section(section, available_width, footer, alternative_header)
    end
    move_cursor_to footer.measure_height(0)
    footer.write_content(0)
  end

  def write_section(section, available_width, footer, alternative_header)
    clazz = Factory.create_class(section.type, document, section, @data.theme, available_width)
    horizontal_cursor = @padding
    remaining_space = cursor - @padding - footer.measure_height(0) # Bottom padding & footer
    unless clazz.fit(horizontal_cursor, remaining_space)
      generate_new_page(horizontal_cursor, footer, alternative_header)
      move_down(@padding) # Top padding for new page
    end

    clazz.write_content(horizontal_cursor)
    move_down(@space_between_components)
  end

  def generate_new_page(horizontal_cursor, footer, alternative_header)
    move_cursor_to footer.measure_height(0)
    footer.write_content(horizontal_cursor)
    start_new_page
    alternative_header.write_content(0)
  end

  def export(export_dir_path, language)
    FileUtils.mkdir_p(export_dir_path) unless File.directory?(export_dir_path)
    save_as(File.join(export_dir_path, "cv_#{language}.pdf"))
  end
end
