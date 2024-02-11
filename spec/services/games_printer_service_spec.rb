# frozen_string_literal: true

require 'spec_helper'

describe GamesPrinterService do
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
  subject(:service) { described_class.new(games, city_tz) }

  describe '#print_games' do
    before do
      allow(STDOUT).to receive(:puts)
      service.print_games
    end

    it 'prints the city timezone' do
      expect(STDOUT).to have_received(:puts).with("\nCity timezone: London - #{city_tz.now.strftime('%d/%m %H:%M')}\n\n")
    end
  end

  describe '#print_game' do
    it 'should print correctly in case of a complete game' do
      game = games.first
      expect { service.send(:print_game, game) }.to output(/Game Detail/).to_stdout
    end

    it 'should not print in case of an incomplete game' do
      game = { 'title' => 'Some Game', 'pubDate' => games.first['pubDate'] }
      expect { service.send(:print_game, game) }.not_to output.to_stdout
    end
  end
end
