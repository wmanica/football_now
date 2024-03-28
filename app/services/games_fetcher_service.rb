# frozen_string_literal: true

require 'httparty'
require 'nokogiri'
require 'open-uri'

class GamesFetcherService
  RSS_URL = 'https://www.zerozero.pt/rss/zapping.php'
  HTML_URL = 'https://www.zerozero.pt/zapping.php'

  class << self
    def fetch_games
      sources = {
        RSS_URL => { :method => method(:process_rss_response), :service => :Rss},
        HTML_URL => { :method => method(:process_html_response), :service => :Html}
      }

      sources.each do |url, processing_info|
        response = HTTParty.get(url)
        return { games: processing_info[:method].call(response), service: processing_info[:service] } if response.success?
      end

      puts Paint['No games fetched. Check source services.', :red]
      { games: nil, service: nil }

    rescue ::SocketError, HTTParty::Error => e
      puts Paint['Check your internet connection. Error message:', :red, e.message]
    end

    private

    def process_rss_response(response)
      response.parsed_response.dig('rss', 'channel', 'item')
    end

    def process_html_response(response)
      document = Nokogiri::HTML(response.body)
      tbody = find_tbody(document)

      tbody.css('tr').map do |tr|
        competition = tr.css('td:last-child').text.gsub("\u00A0", '').strip

        tds = tr.css('td')[0...-1]
        code = tr.at_css('div.micrologo_and_text > div.text > a')&.text

        game_info = tds.map(&:text).join(' ').gsub(code, '').strip
        tv = tr.at_css('td:nth-last-child(2) img')&.[]('alt')

        { info: game_info, tv: tv, competition: competition }
      end
    end

    def find_tbody(document)
      h2 = document.at_css('h2.header')
      table = h2.next_element
      table.css('tbody').first
    end
  end
end
