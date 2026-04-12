# frozen_string_literal: true

module Printers
  class HtmlService < ::PrintersManagerService
    def print_game(game_info)
      game_info => { date:, time:, tv:, teams:, competition: }

      puts "#{offset(date, time)} " +
           "#{Paint[tv, :black, :italic, :inverse]} " +
           "#{Paint[colorize_my_team(teams), :bold]} "+
           "#{Paint[competition, :cyan, :inverse]}\n"
    end
  end
end
