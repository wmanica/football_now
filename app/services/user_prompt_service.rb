# frozen_string_literal: true

require 'tzinfo'
require 'paint'

class UserPromptService
  # Build a mapping from city names to TZInfo identifiers
  CITY_TO_TZ = TZInfo::Timezone.all_identifiers.each_with_object({}) do |id, hash|
    city = id.split('/').last.gsub('_', ' ')
    hash[city.downcase] ||= id
  end
  DEFAULT_TZ = 'Europe/Berlin'

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
      @city_tz = find_tzinfo(input)
    end

    def invalid_city?(input)
      find_tzinfo(input).nil?
    rescue TZInfo::InvalidTimezoneIdentifier
      true
    end

    def cities_tz_list
      # Show a sorted, deduplicated list of city names
      cities = TZInfo::Timezone.all_identifiers.map { |id| id.split('/').last.gsub('_', ' ') }
      cities.uniq.sort.each { |city| puts city }
      puts "\n\n"
    end

    def find_tzinfo(input)
      return TZInfo::Timezone.get(DEFAULT_TZ) if input.strip.empty?
      normalized = input.strip.downcase.gsub('_', ' ')

      if CITY_TO_TZ[normalized] # Try direct city match
        return TZInfo::Timezone.get(CITY_TO_TZ[normalized])
      end

      tz = TZInfo::Timezone.get(input) rescue nil # Try identifier match
      return tz if tz

      match = TZInfo::Timezone.all_identifiers.find { |id| id.downcase.include?(normalized.gsub(' ', '_')) }
      match ? TZInfo::Timezone.get(match) : nil
    end
end
