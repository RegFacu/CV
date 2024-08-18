require_relative '../test_helper'
require 'spacing'

RSpec.describe Spacing do
  document = Prawn::Document.new(page_size: 'A4', margin: 0)
  spacing_value = 10
  theme = {
    spacing: {
      m: spacing_value
    }
  }.to_o
  data = {
    spacing: 'm'
  }.to_o

  available_width = 100

  context 'when initialized' do
    it 'returns a new object' do
      subject = described_class.new(document, data, theme, available_width)
      expect(subject).not_to be_nil
    end
  end

  describe '#fit' do
    it 'is true if remaining_space is greater than the spacing value' do
      subject = described_class.new(document, data, theme, available_width)
      remaining_space = 1000
      expect(subject.fit(0, remaining_space)).to be true
    end

    it 'is true if remaining_space is equals to the spacing value' do
      subject = described_class.new(document, data, theme, available_width)
      remaining_space = spacing_value
      expect(subject.fit(0, remaining_space)).to be true
    end

    it 'is false if remaining_space is less than the spacing value' do
      subject = described_class.new(document, data, theme, available_width)
      remaining_space = 1
      expect(subject.fit(0, remaining_space)).to be true
    end
  end

  describe '#write_content' do
    it 'calls "move_down" with spacing value as parameter' do
      allow(document).to receive(:move_down)
      subject = described_class.new(document, data, theme, available_width)
      subject.write_content(0)
      expect(document).to have_received(:move_down).with(spacing_value)
    end
  end
end
