# frozen_string_literal: true

require 'httparty'

class GamesFetcherService
  class << self
    BASE_URL = 'https://www.zerozero.pt/rss/zapping.php'

    def fetch_games
      response = HTTParty.get(BASE_URL)
      if response.success?
        games = response.parsed_response.dig('rss', 'channel', 'item')
      else
        raise "Failed to get games. Status code: #{response.code}"
      end
      games
    rescue ::SocketError, HTTParty::Error => e
      puts Paint['Check your internet connection. Error message:', ERROR_COLOR, e.message]
    end
  end
end
