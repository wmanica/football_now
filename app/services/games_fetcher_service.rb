# frozen_string_literal: true

require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'byebug'

class GamesFetcherService
	HTML_URL = 'https://www.zerozero.pt/zapping.php'
	RSS_URL = 'https://www.zerozero.pt/rss/zapping.php'
  BROWSER_HEADERS = {
    'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36',
    'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
    'Accept-Language' => 'en-US,en;q=0.9',
    'Referer' => 'https://www.zerozero.pt/',
    'Connection' => 'keep-alive',
    'Upgrade-Insecure-Requests' => '1',
    'Sec-Fetch-Dest' => 'document',
    'Sec-Fetch-Mode' => 'navigate',
    'Sec-Fetch-Site' => 'same-origin',
    'Sec-Fetch-User' => '?1'
  }

  class << self
		def fetch_games
			begin
				response = HTTParty.get('https://www.zerozero.pt/zapping.php', headers: BROWSER_HEADERS, timeout: 30)

				if response.success?
					puts Paint["Processing HTML response", :yellow]
					return { games: process_html_response(response), service: :Html }
				end

        games = process_html_response(file_content)
        return { games: games, service: :Html } if !games.nil?
			rescue => e
				puts Paint["Error fetching from HTML source: #{e.message}", :yellow]
			end

			begin
				response = HTTParty.get('https://www.zerozero.pt/rss/zapping.php', headers: { 'User-Agent' => 'Mozilla/5.0' }, timeout: 30)

				if response.success?
					puts Paint["Processing RSS response", :yellow]
					return { games: process_rss_response(response), service: :Rss }
				end
			rescue => e
				puts Paint["Error fetching from RSS source: #{e.message}", :yellow]
			end

			puts Paint['No games fetched. Check source services.', :red]
			{ games: nil, service: nil }
		end

    private

		def process_rss_response(response)
      response.parsed_response.dig('rss', 'channel', 'item')
    end

    def process_html_response(response)
      html = response.is_a?(String) ? response : response.body
			process_html_response_from_body(html)
    end

    def process_html_response_from_body(body)
      document = body.is_a?(Nokogiri::HTML::Document) ? body : Nokogiri::HTML(body)
      tbody = find_tbody(document)
      return [] unless tbody

      trs = tbody.css('tr')
      trs.map do |tr|
        tds = tr.css('td')
        next if tds.size < 3

        date = tds[0]&.text&.strip&.split(' ')&.last
        time = tds[2]&.text&.strip
        tv = tds[-2]&.at_css('img')&.[]('alt') || tds[-2]&.text&.strip
        team1 = tr.at_css('td.home a')&.text&.strip || tds[5]&.text&.strip
        team2 = tr.at_css('td.away a')&.text&.strip || tds[7]&.text&.strip
				teams = "#{team1} vs #{team2}"
				competition = tds.last&.text&.gsub("\u00A0", '')&.strip

				{ date: date, time: time, tv: tv, teams: teams, competition: competition }
      end.compact
    end

    def find_tbody(document)
      # Prefer the main games table with class 'zztable stats'
      table = document.at_css('table.zztable.stats')
      return table.at_css('tbody') if table
      # Fallback to previous logic
      h2 = document.at_css('h2.header')
      table = h2&.next_element
      while table && table.name != 'table'
        table = table.next_element
      end
      tbody = table&.at_css('tbody')
      tbody || document.at_css('tbody')
    end
  end
end
