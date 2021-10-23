require 'httparty'
require 'nokogiri'
require 'colorize'
require 'byebug'

class FootballNow
    class << self
        BASE_URL = 'http://futebolnow.meiamarca.com/jogos/'
        @@games = []
        
        def start
            response = HTTParty.get(BASE_URL)
            @@doc = Nokogiri::HTML(response.body)

            parse_games

            puts_games

        rescue SocketError => e
            puts "Check your internet connection. Error message: #{e.message}".light_red.bold
        end

        private

        def parse_games
            @@doc.css('td').each do |node|
                next if node.children.text.empty? || node.children.text.include?('RSS')
                
                # TODO: Refactor this ternary condition
                (6..9) === node.children.text.size ? insert_time(node) : insert_game(node)            
            end

            game_index = 0

            @@doc.css('img').drop(1).each do |node|
                next if node.attributes['alt'].value == 'live'

                insert_tv(node, game_index)
                game_index += 1
            end
        end

        def insert_game(node)
            @@games << { game: node.children.text }
        end

        def insert_time(node)
            @@games.last.merge!({ time: DateTime.parse(node.children.text).new_offset('+0100').strftime('%H:%M') })
        end

        def insert_tv(node, game_index)
            @@games[game_index].merge!({ tv: node.attributes['alt'].value })
        end

        def puts_games
            @@games.each do |game|
                puts "#{game[:time].light_cyan.italic} #{game[:tv].light_yellow} - #{ colorize_benfica(game[:game].bold) }\n"
            end
        end

        def colorize_benfica(game_string)
            game_string.include?('Benfica') ? game_string.light_red : game_string.light_white
        end
    end
end

FootballNow.start
