require 'simplecov'
SimpleCov.start

['../../classes', '../../modules'].each do |folder|
  absolute_path = File.expand_path(folder, __FILE__)
  $LOAD_PATH.unshift(absolute_path) unless $LOAD_PATH.include?(absolute_path)
end

require 'rspec'
require 'json'
require 'ostruct'

# Used to convert Hash to OpenStruct
class Hash
  def to_o
    JSON.parse to_json, object_class: OpenStruct
  end
end

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end
