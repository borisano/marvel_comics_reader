require 'rails_helper'

RSpec.describe MarvelApiService, type: :service do
  describe '.get_comics' do
    it 'fails' do
      expect(described_class.get_comics).to eq(true)
    end
  end
end