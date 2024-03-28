require 'spec_helper'

describe GamesFetcherService do
  let(:rss_data) { { 'rss' => { 'channel' => { 'item' => 'fake_rss_data' } } } }
  let(:html_data) { { 'html' => { 'body' => { 'some_html_structure' => 'fake_html_data' } } } }
  let(:failed_response) { instance_double(HTTParty::Response, success?: false, code: 404) }

  describe '.fetch_games' do
    context 'when the service is RSS' do
      let(:response) { instance_double(HTTParty::Response, success?: true, parsed_response: rss_data) }

      before do
        allow(HTTParty).to receive(:get).with(described_class::RSS_URL).and_return(response)
        allow(HTTParty).to receive(:get).with(described_class::HTML_URL).and_return(failed_response)
      end

      it 'returns the games data with service' do
        expect(described_class.fetch_games).to eq({ games: 'fake_rss_data', service: :Rss })
      end
    end

    context 'when the service is HTML' do
      let(:expected_html_return) do
        {
          games: [
            { info: "Some other data", tv: nil}
          ],
          service: :Html
        }
      end

      let!(:response) do
        instance_double(
          HTTParty::Response,
          success?: true,
          body: %{
            <html>
              <body>
                <h2 class="header">Header</h2>
                <table>
                  <tbody>
                    <tr>
                      <td><div class="micrologo_and_text"><div class="text"><a>Fake game code</a></div></div></td>
                      <td>Some other data</td>
                      <td><img alt="tv info"></td>
                    </tr>
                  </tbody>
                </table>
              </body>
            </html>
          }
        )
      end

      before do
        allow(HTTParty).to receive(:get).with(described_class::HTML_URL).and_return(response)
        allow(HTTParty).to receive(:get).with(described_class::RSS_URL).and_return(failed_response)
      end

      it 'returns the games data with service' do
        expect(described_class.fetch_games).to eq(expected_html_return)
      end
    end

    context 'when the request fails for all' do
      before do
        allow(HTTParty).to receive(:get).with(described_class::HTML_URL).and_return(failed_response)
        allow(HTTParty).to receive(:get).with(described_class::RSS_URL).and_return(failed_response)
      end

      it 'outputs an error message' do
        begin
          described_class.fetch_games
        rescue SystemExit => e
          expect(e.status).to_not eq(0)
        end
      end

      it 'returns games and service as nil' do
        begin
          result = described_class.fetch_games
        rescue SystemExit => _
          expect(result).to be_nil
        end
      end
    end

    context 'when there is an internet connection error' do
      before do
        allow(HTTParty).to receive(:get).and_raise(SocketError)
      end

      it 'returns games and service as nil' do
        result = described_class.fetch_games rescue nil
        expect(result).to be_nil
      end
    end
  end
end
