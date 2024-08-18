require_relative '../test_helper'
require 'factory'

RSpec.describe Factory do
  theme = {
    components: {
      footer: {
        padding: 'm',
        height: 100
      }
    },
    spacing: {
      m: 1
    }
  }.to_o
  document = nil
  data = nil
  available_width = nil

  describe '#create_class' do
    it 'raises an error when type is not valid' do
      type = 'TEST'
      expect do
        described_class.create_class(type, document, data, theme, available_width)
      end.to raise_error("Type of class not valid: #{type}")
    end

    it 'returns a Footer object instance when type is "footer"' do
      type = Factory::FOOTER
      subject = described_class.create_class(type, document, data, theme, available_width)
      expect(subject.class).to eq(Footer)
    end
  end
end
