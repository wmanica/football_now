require 'spec_helper'

describe UserPromptService do
  subject(:service) { described_class.new(input_stream) }

  let(:input_stream) { StringIO.new(input_sequence) }

  describe '#user_input' do
    context 'when the input is help then a valid input' do
      let(:input_sequence) { "help\nBerlin\n" }

      before do
        berlin_tz = ActiveSupport::TimeZone.find_tzinfo('Berlin')
        allow(ActiveSupport::TimeZone).to receive(:find_tzinfo).with('Berlin').and_return(berlin_tz)
        allow(ActiveSupport::TimeZone).to receive(:find_tzinfo).with('Help').and_return(nil)
      end

      it 'calls the cities_tz_list method and then waits for a new input' do
        expect(service).to receive(:cities_tz_list)
        service.user_input
        expect(service.instance_variable_get('@city_tz').name).to eq('Europe/Berlin')
      end
    end

    context 'when input is a valid city' do
      let(:input_sequence) { "invalid\ninvalid\nNew York\ninvalid\nBerlin\nexit\n" }

      before do
        ny_tz = ActiveSupport::TimeZone.find_tzinfo('America/New_York')
        allow(ActiveSupport::TimeZone).to receive(:find_tzinfo).with('New York').and_return(ny_tz)
        allow(ActiveSupport::TimeZone).to receive(:find_tzinfo).and_return(nil)
      end
      it 'sets the timezone correctly' do
        service.user_input
        expect(service.instance_variable_get('@city_tz').name).to eq('America/New_York')
      end
    end

    context 'when input is an invalid city' do
      let(:input_sequence) { "invalid\nBerlin\n" }

      it 'sets the timezone to default' do
        service.user_input
        expect(service.instance_variable_get('@city_tz').name).to eq('Europe/Berlin')
      end
    end

    context 'when input is an empty string' do
      let(:input_sequence) { '   ' }

      it 'sets the timezone to default' do
        service.user_input
        expect(service.instance_variable_get('@city_tz').name).to eq('Europe/Berlin')
      end
    end

    context 'when input is exit' do
      let(:input_sequence) { "exit\n" }

      before do
        allow(service).to receive(:exit)
      end

      it 'exits program on "exit" input' do
        expect { service.user_input }.to raise_error(SystemExit)
      end
    end
  end
end
