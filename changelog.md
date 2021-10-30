# Changelog
## [2.0.2] - 2021/10/30
### Added
* Added prompt user input to select the city for timezone
### Changed
* Refactor the date/time calculation

## [2.0.1] - 2021/10/26
### Changed
* Refactor the colorization of strings

## [2.0.0] - 2021/10/25
### Added
* String for timezone offset, preparing for a future user input
### Changed
* bumped Ruby version to 3.0.2
* Refactor to a different url source with rss
* Refactor to use ActiveSupport::TimeZone for the offset change

## [1.0.4] - 2021/10/25
### Added
* Added the day and month before the time for clarification

## [1.0.3] - 2021/10/23
### Added
* Added a blink green bullet point for live games

## [1.0.2] - 2021/10/23
### Added
* Added exception handler for SocketError

## [1.0.1] - 2021/10/22
### Changed
* Refactor to not use index in loops

## [1.0.0] - 2021/10/22
### Added
* Added colorize red when is a Benfica game :D
* Added TV Channels for each match
* Added offset +0100 - from GMT+1 to GMT+2
* Added parser for games and time
