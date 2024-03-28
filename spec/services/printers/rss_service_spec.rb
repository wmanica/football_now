# spec/services/printers/rss_service_spec.rb
RSpec.describe Printers::RssService do
  let(:city_tz) { ActiveSupport::TimeZone["London"] }
  let(:game) { {'title' => 'Some Game - Game Detail', 'pubDate' => '01 Apr 2023 15:10:10 GMT'} }

  subject(:service) { described_class.new([game], city_tz) }

  describe '#print_game' do
    it 'prints the correct message' do
      expect { service.print_game(game) }.to output("THIS NEED TO BE REFACTORED\n").to_stdout
    end
  end
end
