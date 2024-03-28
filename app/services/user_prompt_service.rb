# frozen_string_literal: true

require 'active_support/core_ext/string/conversions'
require 'active_support/isolated_execution_state'
require 'paint'

class UserPromptService
  DEFAULT_TZ = 'Berlin'

  def initialize(input_stream = $stdin)
    @input_stream = input_stream
  end

  def city_prompt
    puts instruction_text
    user_input
    @city_tz
  end

  private

    def instruction_text
      <<~TEXT
        PORTUGUESE SPORT TV CHANNELS

        Enter the name of the city (for example: London) to convert games date/times into
        ** type #{Paint['help', :green]} for the list of cities/timezones **
        ** type #{Paint['exit', :red]} to exit the application **
      TEXT
    end

    def user_input
      input = @input_stream.gets.chomp
      while invalid_city?(input)
        if input.downcase == 'exit'
          Kernel.exit
        elsif input.downcase == 'help'
          cities_tz_list
          input = @input_stream.gets.chomp
        else
          puts "\n\n#{Paint['We could not find in our timezone list:', :red]} #{input.downcase}\n\n"
          input = @input_stream.gets.chomp
        end
      end
      @city_tz = find_tzinfo(input.split.map(&:capitalize).join(' '))
    end

    def invalid_city?(input)
      find_tzinfo(input.capitalize).nil?
    rescue TZInfo::InvalidTimezoneIdentifier
      true
    end

    def cities_tz_list
      ActiveSupport::TimeZone.all.sort_by(&:name).map { |o| puts o.name }
      puts "\n\n"
    end

    def find_tzinfo(input)
      return ActiveSupport::TimeZone.find_tzinfo(DEFAULT_TZ) if input.strip.empty?
      ActiveSupport::TimeZone.find_tzinfo(input)
    end
end
