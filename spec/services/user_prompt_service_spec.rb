RSpec.describe UserPromptService do
  subject(:service) { described_class.new(input_stream) }

  let(:input_stream) { StringIO.new(input_sequence) }

  describe '#city_prompt' do
    context 'when the input is help then a valid input' do
      let(:input_sequence) { "help\nBerlin\n" }

      it 'returns the correct timezone' do
        expect(service.city_prompt.name).to eq('Europe/Berlin')
      end
    end

    context 'when input is a valid city' do
      let(:input_sequence) { "New York\nexit\n" }  # add an exit command

      it 'sets the timezone correctly' do
        expect(service.city_prompt.name).to eq('America/New_York')
      end
    end

    context 'when input is an invalid city' do
      let(:input_sequence) { "invalid\nBerlin\nexit\n" }  # add an exit command

      it 'sets the timezone to default' do
        expect(service.city_prompt.name).to eq('Europe/Berlin')
      end
    end

    context 'when input is an empty string' do
      let(:input_sequence) { '   ' }

      it 'sets the timezone to default' do
        expect(service.city_prompt.name).to eq('Europe/Berlin')
      end
    end

    context 'when input is exit' do
      let(:input_sequence) { "exit\n" }

      it 'exits program on "exit" input' do
        expect { service.city_prompt }.to raise_error(SystemExit)
      end
    end
  end
end
