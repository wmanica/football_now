# frozen_string_literal: true

require 'httparty'
require 'active_support/core_ext/string/conversions'
require 'paint'
require 'byebug'
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

        def follow_up_city_prompt
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
            follow_up_city_prompt
        end

        def find_tzinfo(city)
            ActiveSupport::TimeZone.find_tzinfo(city)

        rescue TZInfo::InvalidTimezoneIdentifier => e
            puts "\n\nWe could not find in out timezone list: #{e.message}"
            follow_up_city_prompt
        end

        def print_games(games)
            puts "\nCity timezone of: #{@city_tz.name}: #{@city_tz.now.strftime('%d/%m %H:%M')}\n\n"

            games.each do |game|
                puts_game(game)
            end
        end

        def puts_game(game)
            game_splitted = game['title'].split(' - ')
        
            puts %Q(#{ datetime_adjust(game['pubDate']) } #{Paint[game_splitted.last, :white, :italic]} - #{ Paint[colorize_benfica(game_splitted.first), :bold] }\n)
        end

        def datetime_adjust(pubDate)
            date_splitted = pubDate.split(' ').drop(1)

            new_time = offset(date_splitted)
            date = date_adjust(date_splitted, new_time)

            "#{date} #{new_time}"
        end

        def offset(date_splitted)
            Time.zone = 'London'
            game_bst_time = Time.zone.parse("#{date_splitted[2]}-#{date_splitted[1]}-#{date_splitted.first} #{date_splitted.last}")

            game_user_time = game_bst_time.in_time_zone(@city_tz)

            "#{game_user_time.strftime('%H:%M')}#{Paint[' •', :green, :blink] if is_live?(game_user_time)}"
        end

        def is_live?(game_user_time)
            plus_2_hours = game_user_time.hour + 2 >= 24 ? (game_user_time.hour + 2) - 24 : game_user_time.hour

            if game_user_time.hour + 2 >= 24
                (game_user_time..game_user_time.next_day.change(hour: plus_2_hours)).cover? Time.now.in_time_zone(@city_tz)
            else
                (game_user_time..game_user_time.change(hour: plus_2_hours)).cover? Time.now.in_time_zone(@city_tz)
            end

        end

        def date_adjust(date_splitted, new_time)
            methods = []
            # TODO: problem realated the date for when time is between 00:00 and 01:00. It is changing even when it should not
            # TODO: possible solution check if the day wis the same of game_bst_time ?
            # byebug if new_time == '00:30'

            ('00:00'..'01:00').cover?(new_time) ? methods << [:days_since, 1] : nil
            methods << [:strftime, '%d/%m']

            methods.inject("#{date_splitted[0]}/#{date_splitted[1]}/#{date_splitted[2]}".to_date) { |o, method_and_args| o.public_send(*method_and_args) }
        end

        def colorize_benfica(game_string)
            game_string.include?('Benfica') ? Paint[game_string, :red] : Paint[game_string, :white, :bright]
        end
    end
end

FootballNow.start
