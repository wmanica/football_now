require_relative './app/football_now'

namespace :start do
  task :football_now do
    FootballNow.start
  end
end
