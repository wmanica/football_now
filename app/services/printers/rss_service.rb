# frozen_string_literal: true

module Printers
  class RssService < ::PrintersManagerService
    def print_game(game)
      game_info = game['title']
      return if game_info.size < 2

      date, time, teams, tv_channel = parse_date_teams(game_info)

      puts "#{offset(date, time)} " +
             "#{Paint[tv_channel, :gray, :italic]}" +
             "#{SEPARATOR}" +
             "#{Paint[colorize_my_team(teams), :bold]}\n"
    end

    private

      def parse_date_teams(game_info)
        match_data = game_info.match(/^(.*)\s+-\s+(\d{1,2}\/\d{1,2})\s(\d{1,2}:\d{1,2})\s-\s(.*)$/)

        teams = match_data[1]
        date = match_data[2]
        time = match_data[3]
        tv_channel = match_data[4]

        [date, time, teams, tv_channel]
      end
  end
end
