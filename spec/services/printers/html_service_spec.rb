# spec/services/printers/html_service_spec.rb
RSpec.describe Printers::HtmlService do
  let(:city_tz) { ActiveSupport::TimeZone["London"] }
  let(:game) { {info: '01/01 00:00  Team1 - Team2', tv: 'TV Channel'} }

  subject(:service) { described_class.new([game], city_tz) }

  describe '#print_game' do
    it 'prints the correct message' do
      date, time, teams = service.send(:parse_date_teams, game[:info])
      expect { service.print_game(game) }
        .to output(/#{date} #{time}.*#{game[:tv]}.*#{teams}/).to_stdout
    end
  end

  describe '#parse_date_teams' do
    it 'returns correct values' do
      date, time, teams = service.send(:parse_date_teams, game[:info])
      expect(date).to eq '01/01'
      expect(time).to eq '00:00'
      expect(teams).to eq 'Team1 - Team2'
    end
  end
end
