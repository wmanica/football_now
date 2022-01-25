# frozen_string_literal: true

require 'httparty'
require 'active_support/core_ext/string/conversions'
require 'paint'

# TODO: add docker_build.sh and docker_run.sh scripts to build and run the docker's commands

class FootballNow
    class << self
        BASE_URL = 'https://www.zerozero.pt/rss/zapping.php'
        
        def start            
            response = HTTParty.get(BASE_URL)
            games = response.parsed_response['rss']['channel']['item']

            city_prompt

            print_games(games)

        rescue SocketError => e
            puts "#{Paint['Check your internet connection. Error message:', :red]} #{e.message}"
        end

        private

        def city_prompt
            puts "\nPORTUGUESE SPORT TV CHANNELS"
            puts "\nEnter the city to convert games date/times into"
            puts "\nNOTE: type #{Paint['help', :green]} for the list of cities/timezones\n"

            user_input
        end

        def user_input
            input = gets.chomp
            input.downcase == 'help' ? cities_tz_list : @city_tz = find_tzinfo(input.capitalize)
        end

        def cities_tz_list
            ActiveSupport::TimeZone.all.sort_by { |o| o.name }.map {|o| puts o.name} 
            city_prompt
        end

        def find_tzinfo(input)
            input.blank? ? ActiveSupport::TimeZone.find_tzinfo('Berlin') : ActiveSupport::TimeZone.find_tzinfo(input)
        rescue TZInfo::InvalidTimezoneIdentifier => e
            puts "\n\n#{Paint['We could not find in out timezone list:', :red]} #{e.message}"
            city_prompt
        end

        def print_games(games)
            system("clear")

            puts "\nCity timezone: #{@city_tz.name} - #{@city_tz.now.strftime('%d/%m %H:%M')}\n\n"

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
