# spec for PrintersManagerService
RSpec.describe PrintersManagerService do
  # Create a test class that inherits from PrintersManagerService
  class TestClassPrintersService < PrintersManagerService
    def print_game(game)
      # Doesn't need to do anything
    end
  end

  let(:city_tz) { ActiveSupport::TimeZone["London"] }
  let(:games) {
    [
      {
        'title' => 'Some Game - Game Detail',
        'pubDate' => '01 Apr 2023 15:10:10 GMT'
      },
      {
        'title' => 'Some Other Game - Other Details',
        'pubDate' => '02 Apr 2023 16:10:10 GMT'
      }
    ]
  }

  # Use the test class for your subject
  subject(:service) { TestClassPrintersService.new(games, city_tz) }

  describe '#print_games' do
    before do
      allow(STDOUT).to receive(:puts)
      allow(service).to receive(:print_game)
      service.print_games
    end

    it 'prints the city timezone' do
      expect(STDOUT).to have_received(:puts).with("\nCity timezone: #{city_tz.name} - #{city_tz.now.strftime('%d/%m %H:%M')}\n\n")
    end

    it 'prints each game' do
      games.each do |game|
        expect(service).to have_received(:print_game).with(game)
      end
    end
  end
end
