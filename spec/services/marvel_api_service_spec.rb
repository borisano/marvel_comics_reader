require 'rails_helper'
require 'net/http'

RSpec.describe MarvelApiService, type: :service do
  describe '.fetch_chronological_comics' do
    let(:limit) { 100 }
    let(:page) { 0 }

    context 'when API request is successful' do
      let(:offset) { page * limit }
      let(:url) { MarvelApiService.send(:build_url, offset, limit) }
      let(:response_body) { { 'data' => { 'results' => [{ 'title' => 'Comic 1', 'issueNumber' => 1, 'images' => [{ 'path' => 'path', 'extension' => 'jpg' }], 'dates' => [] }] } }.to_json }
      let(:response) { Net::HTTPSuccess.new('1.1', '200', 'OK') }
      let(:expected_comics) { [{ title: 'Comic 1', issue_number: 1, cover_url: 'path.jpg', dates: [] }] }

      # before do
      #   allow(MarvelApiService).to receive(:make_api_request).with(url).and_return(response)
      #   allow(response).to receive(:body).and_return(response_body)
      # end

      it 'returns the chronological comics' do
        comics = MarvelApiService.fetch_chronological_comics(limit, page)
        byebug
        expect(comics).to eq(expected_comics)
      end
    end

    context 'when API request fails' do
      let(:offset) { page * limit }
      let(:url) { MarvelApiService.send(:build_url, offset, limit) }
      let(:response) { Net::HTTPBadRequest.new('1.1', '400', 'Bad Request') }

      before do
        allow(MarvelComicsFetcher).to receive(:make_api_request).with(url).and_return(response)
      end

      it 'prints an error message' do
        expect { MarvelApiService.fetch_chronological_comics(limit, page) }.to output("Error fetching comics: #{response.code}\n").to_stdout
      end
    end
  end
end