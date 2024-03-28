# frozen_string_literal: true

class PrintersManagerService
  DATE_FORMAT = '%d/%m %H:%M'
  DATE_SEPARATOR = '/'
  DEFAULT_TIME_ZONE = 'Lisbon'
  MY_TEAM = 'Benfica'
  SEPARATOR = ' - '

  def initialize(games, city_tz)
    @games = games
    @city_tz = city_tz
  end

  def print_games
    system('clear')

    print_city_tz

    games = self.is_a?(Printers::HtmlService) ? @games.take(70) : @games

    games.each do |game|
      print_game(game)
    end
  end

  private

    def print_city_tz
      puts "\nCity timezone: #{@city_tz.name} - #{@city_tz.now.strftime('%d/%m %H:%M')}\n\n"
    end

    # TODO: Update this when RSS Zappping of Zerozero is back working. I need to have it working to remember how the data
    #   is parsed to then refactor offset to be more agnostic between Rss and Html implementation
    # def offset(pub_date)
    #   date_split = pub_date.split(' ')
    #
    #   raise ArgumentError, 'Invalid date format' if date_split.size < 2
    #
    #   date_part = date_split.drop(1)
    #   Time.zone = 'London'
    #   bst_time = Time.zone.parse("#{date_part[2]}-#{date_part[1]}-#{date_part.first} #{date_part.last}")
    #   user_time = bst_time.in_time_zone(@city_tz)
    #
    #   "#{user_time.strftime(DATE_FORMAT)} #{Paint['•', :green, :blink] if live?(user_time)}"
    # end

    def offset(date, time)
      return "#{date} --:-- " if time == "-"

      current_year = Date.today.year
      date = "#{date}#{DATE_SEPARATOR}#{current_year}"

      Time.zone = DEFAULT_TIME_ZONE
      bst_time = Time.zone.parse("#{date} #{time}")
      user_time = bst_time.in_time_zone(@city_tz)

      "#{user_time.strftime(DATE_FORMAT)} #{Paint['•', :green, :blink] if live?(user_time)}"
    end

    def live?(user_time)
      current_time = (@current_time ||= Time.now).in_time_zone(@city_tz)
      (user_time..user_time.advance(hours: +2)).cover? current_time
    end

    def colorize_my_team(game_string)
      game_string.include?(MY_TEAM) ? Paint[game_string, :red] : Paint[game_string, :white, :bright]
    end
end
