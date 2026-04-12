RSpec.describe Printers::HtmlService do
  let(:city_tz) { TZInfo::Timezone.get("Europe/London") }
  let(:game) { {date: '01/01', time: '00:00', teams: 'Team1 - Team2', tv: 'TV Channel', competition: 'LaLiga'} }

  subject(:service) { described_class.new([game], city_tz) }

  describe '#print_game' do
    it 'prints the correct message' do
      expect { service.print_game(game) }
        .to output(/01\/01 00:00.*TV Channel.*Team1 - Team2.*LaLiga/).to_stdout
    end
  end
end
