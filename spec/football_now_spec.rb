require 'spec_helper'

describe FootballNow do
  describe '.start' do
    let(:city_tz) { 'timezone' }

    let(:games_printer_service) { instance_double(PrintersManagerService) }
    let(:user_prompt_service) { instance_double(UserPromptService, city_prompt: city_tz) }

    before do
      allow(UserPromptService).to receive(:new).and_return(user_prompt_service)
      allow(PrintersManagerService).to receive(:new).and_return(games_printer_service)
      allow(games_printer_service).to receive(:print_games)
    end

    context 'when there are no exceptions' do
      context "when service is 'Rss'" do
        let(:results) { { games: 'games', service: 'Rss' } }

        it 'fetches games, prompts city timezone, and prints games' do
          allow(GamesFetcherService).to receive(:fetch_games).and_return(results)

          described_class.start
          expect(GamesFetcherService).to have_received(:fetch_games)
          expect(user_prompt_service).to have_received(:city_prompt)
          expect(games_printer_service).to have_received(:print_games)
        end
      end

      context "when service is 'Html'" do
        let(:results) { { games: 'games', service: 'Html' } }

        it 'fetches games, prompts city timezone, and prints games' do
          allow(GamesFetcherService).to receive(:fetch_games).and_return(results)

          described_class.start
          expect(GamesFetcherService).to have_received(:fetch_games)
          expect(user_prompt_service).to have_received(:city_prompt)
          expect(games_printer_service).to have_received(:print_games)
        end
      end
    end

    context 'when an error occurs' do
      let(:error) { StandardError.new('This is a test error') }
      let(:results) { { games: 'games', service: 'Rss' } }

      it 'rescues the standard error and outputs an error message' do
        allow(GamesFetcherService).to receive(:fetch_games).and_raise(error)
        allow(Paint).to receive(:[]).and_return('an error occurred')

        expect { described_class.start }.to output("an error occurred\n").to_stdout
      end
    end
  end
end
