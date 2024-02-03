# frozen_string_literal: true

require 'httparty'
require 'active_support/core_ext/string/conversions'
require 'active_support/isolated_execution_state'
require 'paint'

# TODO: add docker_build.sh and docker_run.sh scripts to build and run the docker's commands

class FootballNow
  class << self
    BASE_URL = 'https://www.zerozero.pt/rss/zapping.php'
    DATE_FORMAT = '%d/%m %H:%M'
    DETAIL_SEPARATOR = ' - '
    MY_TEAM = 'Benfica'

    def start
      response = HTTParty.get(BASE_URL)
      handle_response(response)
    rescue SocketError, HTTParty::Error => e
      puts "#{Paint['Check your internet connection. Error message:', :red]} #{e.message}"
    end

    private

    def handle_response(response)
      return puts "#{Paint['Failed to get games. Status code:', :red]} #{response.code}" unless response.success?

      games = response.parsed_response.dig('rss', 'channel', 'item')
      return puts "#{Paint['No games found.', :red]}" unless games

      city_prompt

      print_games(games)
    end

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
      input = gets.chomp
      if input.downcase == 'help'
        cities_tz_list
      else
        @city_tz = find_tzinfo(input.capitalize)
        # If @city_tz is not correctly initialised, initialise with default value
        @city_tz ||= ActiveSupport::TimeZone.find_tzinfo('Berlin')
      end
    end

    def cities_tz_list
      ActiveSupport::TimeZone.all.sort_by(&:name).map { |o| puts o.name }
      city_prompt
    end

    def find_tzinfo(input)
      return ActiveSupport::TimeZone.find_tzinfo('Berlin') if input.blank?

      ActiveSupport::TimeZone.find_tzinfo(input)
    rescue TZInfo::InvalidTimezoneIdentifier
      puts "\n\n#{Paint['We could not find in our timezone list:', :red]} #{input}"
      city_prompt
    end

    def print_games(games)
      system('clear')
      display_city_timezone

      games.each do |game|
        print_game(game)
      end
    end

    def display_city_timezone
      puts "\nCity timezone: #{@city_tz.name} - #{@city_tz.now.strftime('%d/%m %H:%M')}\n\n"
    end

    def print_game(game)
      game_details = game['title'].split(DETAIL_SEPARATOR)

      return if game_details.size < 2

      game_information = "#{offset(game['pubDate'], @city_tz)} "
      game_information << "#{Paint[game_details.last, :white, :italic]}#{DETAIL_SEPARATOR}"
      game_information << "#{Paint[colorize_my_team(game_details.first), :bold]}\n"

      puts game_information
    end

    def offset(pub_date, city_tz)
      date_split = pub_date.split(' ')

      raise ArgumentError, 'Invalid date format' if date_split.size < 2

      date_part = date_split.drop(1)
      Time.zone = 'London'
      bst_time = Time.zone.parse("#{date_part[2]}-#{date_part[1]}-#{date_part.first} #{date_part.last}")

      user_time = bst_time.in_time_zone(city_tz)

      "#{user_time.strftime(DATE_FORMAT)} #{Paint['•', :green, :blink] if live?(user_time)}"
    end

    def live?(user_time)
      current_time = (@current_time ||= Time.now).in_time_zone(@city_tz)
      (user_time..user_time.advance(hours: +2)).cover? current_time
    end

    def colorize_my_team(game_string)
      game_string.include?(MY_TEAM) ? Paint[game_string, :red] : Paint[game_string, :white, :bright]
    end
  end
end

FootballNow.start
