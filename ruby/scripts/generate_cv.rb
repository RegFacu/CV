["../../classes", "../../modules"].each do |folder|
    absolute_path = File.expand_path(folder, __FILE__)
    $LOAD_PATH.unshift(absolute_path) unless $LOAD_PATH.include?(absolute_path)
end

require 'optparse'
require 'json'

require 'CV'

def main(path, export_dir_path)
    json = JSON.parse(File.read(path), object_class: OpenStruct)
    cv = CV.new(json)
    cv.write_content()
    cv.export(export_dir_path, File.basename(path, '.json'))
end

if __FILE__ == $0
    options = {}
    parser = OptionParser.new do |opts|
        opts.on('-h', '--help', 'Show help') do |help|
            options[:help] = true
        end
        opts.on('--path=PATH', 'Path to the CV config to be used to generate the PDF') do |path|
            options[:path] = path
        end
        opts.on('--export_dir_path=EXPORT_DIR_PATH', 'Dir path where the PDF will be generated') do |export_dir_path|
            options[:export_dir_path] = export_dir_path
        end
    end

    parser.parse!
    if options[:help]
        puts parser.help
        exit 1
    end

    begin
        mandatory_parameters = [:path]
        missing_parameters = mandatory_parameters.select { |param| options[param].nil?}
        raise OptionParser::MissingArgument.new(missing_parameters.join(',')) unless missing_parameters.empty?
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument
        puts $!.to_s
        puts parser
        exit 1
    end

    main(options[:path], options[:export_dir_path] || 'exported')
end