require 'rails_helper'
require 'net/http'

RSpec.describe MarvelApiService do
  describe '.fetch' do
    let(:page) { 1 }
    let(:limit) { 15 }
    let(:offset) { (page - 1) * limit }
    let(:url) { "https://gateway.marvel.com:443/v1/public/comics?orderBy=issueNumber&limit=#{limit}&offset=#{offset}&ts=#{ts}&apikey=#{MarvelApiService::MARVEL_PUBLIC_KEY}&hash=#{hash}" }
    let(:ts) { Time.now.to_i.to_s }
    let(:hash) { MarvelApiService.hash(ts) }
    let(:response_body) { { 'data' => { 'results' => [{ 'title' => 'Comic 1', 'description' => 'Description 1', 'images' => [{ 'path' => 'path1', 'extension' => 'jpg' }] }] } }.to_json }
    let(:response) { instance_double(Net::HTTPSuccess, body: response_body) }

    before do
      allow(Net::HTTP).to receive(:start).and_return(response)
    end

    context 'when the API request is successful' do
      it 'returns an array of comics' do
        comics = MarvelApiService.fetch(page, limit)

        expect(comics).to be_an(Array)
        expect(comics.size).to eq(1)
        expect(comics.first).to include(title: 'Comic 1', description: 'Description 1', cover_url: 'path1.jpg')
      end
    end

    context 'when the API request fails' do
      let(:response) { instance_double(Net::HTTPResponse, code: '500') }

      before do
        allow(response).to receive(:code).and_return("500")
      end

      it 'prints an error message' do
        expect { MarvelApiService.fetch(page, limit) }.to output("Error fetching comics: 500\n").to_stdout
      end
    end
  end
end