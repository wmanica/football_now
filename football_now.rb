require 'httparty'
require 'nokogiri'
require 'colorize'
require 'byebug'

class FootballNow
    class << self
        BASE_URL = 'http://futebolnow.meiamarca.com/jogos/'
        @@games = {}
        
        def get_games
            response = HTTParty.get(BASE_URL)
            @@doc = Nokogiri::HTML(response.body)

            parse_games

            puts_games
        end

        private

        def parse_games
            @@doc.css('td').each_with_index do |node, index|
                next if node.children.text.empty? || node.children.text.include?('RSS')
                
                # TODO: Refactor this ternary condition
                (6..9) === node.children.text.size ? set_time(node, index) : set_game(node, index)            
            end

            @@doc.css('img').drop(1).each_with_index do |node, index|
                set_tv(node, index)
            end
        end

        def set_game(node, index)
            @@games[index] = { game: node.children.text }
        end

        # TODO: Refactor the use of the index of the hash @@games
        def set_time(node, index)
            @@games[index - 1].merge!({ time: DateTime.parse(node.children.text).new_offset('+0100').strftime('%H:%M') })
        end

        def set_tv(node, index)
            @@games[index * 3].merge!({ tv: node.attributes['alt'].value })
        end

        def puts_games
            @@games.each do |game|
                puts "#{game[1][:time].light_cyan.italic} #{game[1][:tv].light_yellow} - #{ colorize_benfica(game[1][:game].bold) }\n"
            end
        end

        def colorize_benfica(game_string)
            game_string.include?('Benfica') ? game_string.light_red.blink : game_string.light_white
        end
    end
end

FootballNow.get_games