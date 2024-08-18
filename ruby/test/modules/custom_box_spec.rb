require_relative '../test_helper'
require 'custom_box'

RSpec.describe CustomBox do
  options = {
    document: Prawn::Document.new(page_size: 'A4', margin: 0)
  }
  text = 'Testing'

  context 'when initialized' do
    it 'returns a new object with the expected initial text' do
      subject = described_class.new(text, options)
      expect(subject.initial_text).to eq(text)
    end
  end

  describe '#render' do
    it 'does not set measured_width when dry_run mode not defined' do
      options.delete(:dry_run)
      subject = described_class.new(text, options)
      subject.render(options)
      expect(subject.measured_width).to be_nil
    end

    it 'does not set measured_width when dry_run mode is false' do
      options[:dry_run] = false
      subject = described_class.new(text, options)
      subject.render(options)
      expect(subject.measured_width).to be_nil
    end

    it 'sets measured_width when dry_run mode is true' do
      subject = described_class.new(text, options)
      options[:dry_run] = true
      subject.render(options)
      expect(subject.measured_width).to be_positive
    end
  end
end
