# frozen_string_literal: true

require 'httparty'
require 'active_support/core_ext/string/conversions'
require 'paint'
# require 'byebug' only needed for debugging. Comment for no need to install it
class FootballNow
    class << self
        BASE_URL = 'https://www.zerozero.pt/rss/zapping.php'
        
        def start            
            response = HTTParty.get(BASE_URL)
            games = response.parsed_response['rss']['channel']['item']

            city_prompt

            print_games(games)

        rescue SocketError => e
            puts "Check your internet connection. Error message: #{e.message}".light_red.bold
        end

        private

        def city_prompt
            puts "\nPORTUGUESE SPORTV TV CHANNELS"
            puts "\nEnter the city to convert games date/times into"
            puts "\nNOTE: type #{Paint['help', :green]} for the list of cities/timezones\n"

            user_input
        end

        def user_input
            input = gets.chomp

            if input.downcase == 'help'
                cities_tz_list
            else
                @city_tz = find_tzinfo(input)
            end 
        end

        def cities_tz_list
            ActiveSupport::TimeZone.all.each { |city| puts city.name  }
            city_prompt
        end

        def find_tzinfo(city)
            ActiveSupport::TimeZone.find_tzinfo(city)

        rescue TZInfo::InvalidTimezoneIdentifier => e
            puts "\n\nWe could not find in out timezone list: #{e.message}"
            city_prompt
        end

        def print_games(games)
            puts "\nCity timezone of: #{@city_tz.name}: #{@city_tz.now.strftime('%d/%m %H:%M')}\n\n"

            games.each do |game|
                puts_game(game)
            end
        end

        def puts_game(game)
            game_splitted = game['title'].split(' - ')
        
            puts %Q(#{ offset(game['pubDate']) } #{Paint[game_splitted.last, :white, :italic]} - #{ Paint[colorize_benfica(game_splitted.first), :bold] }\n)
        end

        def offset(pubDate)
            date_splitted = pubDate.split(' ').drop(1)

            Time.zone = 'London'
            game_bst_time = Time.zone.parse("#{date_splitted[2]}-#{date_splitted[1]}-#{date_splitted.first} #{date_splitted.last}")

            game_user_time = game_bst_time.in_time_zone(@city_tz)

            "#{game_user_time.strftime('%d/%m %H:%M')}#{Paint[' •', :green, :blink] if is_live?(game_user_time)}"
        end

        def is_live?(game_user_time)
            (game_user_time..game_user_time.advance(hours: +2)).cover? Time.now.in_time_zone(@city_tz)
        end

        def colorize_benfica(game_string)
            game_string.include?('Benfica') ? Paint[game_string, :red] : Paint[game_string, :white, :bright]
        end
    end
end

FootballNow.start
