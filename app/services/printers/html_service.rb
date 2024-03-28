# frozen_string_literal: true

module Printers
  class HtmlService < ::PrintersManagerService
    def print_game(game)
      date, time, teams = parse_date_teams(game[:info])

      puts "#{offset(date, time)} " +
             "#{Paint[game[:tv], :gray, :italic]}" +
             "#{SEPARATOR}" +
             "#{Paint[colorize_my_team(teams), :bold]} "+
             # "#{SEPARATOR}" +
             "#{Paint[game[:competition], :cyan, :inverse]}\n"
    end

    private

      def parse_date_teams(game_info)
        date, remaining_info = game_info.match(/(\d{1,2}\/\d{1,2})(.*)/).captures
        time, teams = remaining_info.strip.split(/\s{2,}/, 2)
        time = "-" if time.empty?
        [date, time, teams]
      end
  end
end
