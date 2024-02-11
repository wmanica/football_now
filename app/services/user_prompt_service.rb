# frozen_string_literal: true

require 'active_support/core_ext/string/conversions'
require 'active_support/isolated_execution_state'
require 'paint'

class UserPromptService
  DEFAULT_TZ = 'Berlin'

  def city_prompt
    content = <<~TEXT
      PORTUGUESE SPORT TV CHANNELS

      Enter the name of the city (for example: London) to convert games date/times into
      ** type #{Paint['help', :green]} for the list of cities/timezones **
    TEXT

    puts content
    user_input
  end

  def user_input
    input = STDIN.gets.chomp
    if input.downcase == 'help'
      cities_tz_list
    else
      @city_tz = find_tzinfo(input.capitalize)
      # If @city_tz is not correctly initialised, initialise with default value
      @city_tz ||= ActiveSupport::TimeZone.find_tzinfo(DEFAULT_TZ)
    end
  end

  def cities_tz_list
    ActiveSupport::TimeZone.all.sort_by(&:name).map { |o| puts o.name }
    city_prompt
  end

  def find_tzinfo(input)
    return ActiveSupport::TimeZone.find_tzinfo(DEFAULT_TZ) if input.blank?

    ActiveSupport::TimeZone.find_tzinfo(input)
  rescue TZInfo::InvalidTimezoneIdentifier
    puts "\n\n#{Paint['We could not find in our timezone list:', :red]} #{input}"
    city_prompt
  end
end
