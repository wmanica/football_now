# frozen_string_literal: true

require_relative 'services/games_fetcher_service'
require_relative 'services/user_prompt_service'
require_relative 'services/games_printer_service'

# TODO: add docker_build.sh and docker_run.sh scripts to build and run the docker's commands

class FootballNow
  class << self
    def start
      fetch_data_and_start
    rescue StandardError => e
      puts Paint['An error occurred:', :red, e]
    end

    private

    def fetch_data_and_start
      games = GamesFetcherService.fetch_games
      city_tz = UserPromptService.new.city_prompt
      GamesPrinterService.new(games, city_tz).print_games
    end
  end
end
