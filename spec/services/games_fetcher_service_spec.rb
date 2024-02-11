require 'spec_helper'

describe GamesFetcherService do
  let(:games_data) { 'fake_games_data' }
  let(:response) { instance_double(HTTParty::Response, success?: true, parsed_response: { 'rss' => { 'channel' => { 'item' => games_data } } }) }
  let(:failed_response) { instance_double(HTTParty::Response, success?: false, code: '404') }

  describe '.fetch_games' do
    context 'when the request is successful' do
      before do
        allow(HTTParty).to receive(:get).with(described_class::BASE_URL).and_return(response)
      end

      it 'returns the games data' do
        expect(described_class.fetch_games).to eq(games_data)
      end
    end

    context 'when the request fails' do
      before do
        allow(HTTParty).to receive(:get).with(described_class::BASE_URL).and_return(failed_response)
      end

      it 'raises an exception' do
        expect { described_class.fetch_games }.to raise_error(RuntimeError, 'Failed to get games. Status code: 404')
      end
    end

    context 'when there is a network error' do
      let(:error_message) { 'Check your internet connection. Error message:' }

      before do
        allow(HTTParty).to receive(:get).with(described_class::BASE_URL).and_raise(SocketError)
        allow(Paint).to receive(:[]).and_return(error_message)
      end

      it 'outputs an error message' do
        expect { described_class.fetch_games }.to output(include(error_message)).to_stdout
      end
    end
  end
end
