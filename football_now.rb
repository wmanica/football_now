# frozen_string_literal: true

require 'httparty'
require 'active_support/core_ext/string/conversions'
require 'paint'
class FootballNow
    class << self
        BASE_URL = 'https://www.zerozero.pt/rss/zapping.php'
        
        def start            
            response = HTTParty.get(BASE_URL)
            games = response.parsed_response['rss']['channel']['item']

            games.each do |game|
                puts_game(game)
            end

        rescue SocketError => e
            puts "Check your internet connection. Error message: #{e.message}".light_red.bold
        end

        private
        
        def puts_game(game)
            game_splitted = game['title'].split(' - ')
            puts %Q(#{ datetime_adjust(game['pubDate']) } #{Paint[game_splitted.last, :white, :italic]} - #{ Paint[colorize_benfica(game_splitted.first), :bold] }\n)
        end

        def datetime_adjust(date)
            date_splitted = date.split(' ').drop(1)

            new_time = offset(date_splitted, 'Berlin')
            date = date_adjust(date_splitted, new_time)

            "#{date} #{new_time}"
        end

        def offset(date_splitted, city_tz)
            Time.zone = 'London'
            game_bst_time = Time.zone.parse("#{date_splitted[2]}-#{date_splitted[1]}-#{date_splitted.first} #{date_splitted.last}")

            tz = ActiveSupport::TimeZone.find_tzinfo(city_tz)
            game_cest_time = game_bst_time.in_time_zone(tz)

            "#{game_cest_time.strftime('%H:%M')}#{Paint[' •', :light_green, :blink] if is_live?(game_cest_time, tz)}"
        end

        def is_live?(game_cest_time, tz)
            (game_cest_time..game_cest_time.change(hour: game_cest_time.hour + 2)).cover? Time.now.in_time_zone(tz)
        end

        def date_adjust(date_splitted, new_time)
            methods = []
            new_time == '00:00' ? methods << [:days_since, 1] : nil
            methods << [:strftime, '%d/%m']

            methods.inject("#{date_splitted[0]}/#{date_splitted[1]}/#{date_splitted[2]}".to_date) { |o, method_and_args| o.public_send(*method_and_args) }
        end

        def colorize_benfica(game_string)
            game_string.include?('Benfica') ? Paint[game_string, :red] : Paint[game_string, :white, :bright]
        end
    end
end

FootballNow.start
