# frozen_string_literal: true

module Printers
  class RssService < ::PrintersManagerService
    def print_game(game)
      game_details = game['title'].split(TV_SEPARATOR)
      return if game_details.size < 2

      puts "THIS NEED TO BE REFACTORED"
      exit

      # TODO when the RSS Zapping of zerozero is back working I need to do some refactor for this to work
      # game_information = "#{offset(game['pubDate'])} " +
      #   "#{Paint[game_details.last, :white, :italic]}#{DETAIL_SEPARATOR}" +
      #   "#{Paint[colorize_my_team(game_details.first), :bold]}\n"
      #
      # puts game_information
    end
  end
end
