RSpec.describe Printers::RssService do
  let(:city_tz) { ActiveSupport::TimeZone["London"] }

  subject(:service) { described_class.new([game], city_tz) }

  describe '#print_game' do
    context 'when the title has a proper format' do
      let(:game) { {'title' => 'FC Genoa x Cagliari FC - 29/04 19:45 - SportTv3', 'pubDate' => '01 Apr 2023 15:10:10 GMT'} }

      it 'prints the correct game info' do
        expect { service.print_game(game) }.to output(/29\/04 19:45.*SportTv3.*FC Genoa x Cagliari FC/).to_stdout
      end
    end

    context 'when the title has only one digit for date and time' do
      let(:game) { {'title' => 'FC Genoa x Cagliari FC - 9/4 1:9 - SportTv3', 'pubDate' => '01 Apr 2023 15:10:10 GMT'} }

      it 'prints the correct game info' do
        expect { service.print_game(game) }.to output(/09\/04 01:09.*SportTv3.*FC Genoa x Cagliari FC/).to_stdout
      end
    end

    context 'when the title is missing' do
      let(:game) { {'title' => '', 'pubDate' => '01 Apr 2023 15:10:10 GMT'} }

      it 'does not print anything' do
        expect { service.print_game(game) }.not_to output.to_stdout
      end
    end
  end
end
