require 'spec_helper'

describe FootballNow do
  describe '.start' do
    let(:city_tz) { 'timezone' }
    let(:results) { 'games' }

    let(:games_printer_service) { instance_double(GamesPrinterService) }
    let(:user_prompt_service) { instance_double(UserPromptService, city_prompt: city_tz) }

    before do
      allow(GamesFetcherService).to receive(:fetch_games).and_return(results)
      allow(UserPromptService).to receive(:new).and_return(user_prompt_service)
      allow(GamesPrinterService).to receive(:new).and_return(games_printer_service)
      allow(games_printer_service).to receive(:print_games)
    end

    context 'when there are no exceptions' do
      it 'fetches games, prompts city timezone, and prints games' do
        described_class.start
        expect(GamesFetcherService).to have_received(:fetch_games)
        expect(user_prompt_service).to have_received(:city_prompt)
        expect(games_printer_service).to have_received(:print_games)
      end
    end

    context 'when an error occurs' do
      let(:error) { StandardError.new('This is a test error') }

      it 'rescues the standard error and outputs an error message' do
        allow(GamesFetcherService).to receive(:fetch_games).and_raise(error)
        allow(Paint).to receive(:[]).and_return('an error occurred')

        expect { described_class.start }.to output("an error occurred\n").to_stdout
      end
    end
  end
end
