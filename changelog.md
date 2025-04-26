# Changelog
## [6.0.0] - 2025/04/26
### Added
* Added a `.ruby-version` file specifying Ruby 3.4.3.

### Changed
* Refactor Dockerfile


## [5.2.0] - 2025/04/15
### Changed
* Bumped Ruby version to 3.4.3 for project and also in Dockerfile


## [5.2.0] - 2024/03/28
### Changed
*  Refactor RssService 


## [5.1.0] - 2024/03/28
### Added
* Now with the competitions info


## [5.0.0] - 2024/03/28
### Added
* Introduced two new service classes: HtmlService and RssService

### Changed
* Refactor fetching of games, to now be able to use an HTML source
* GamesFetcherService to handle RSS and HTML sources


## [4.0.1] - 2024/03/05
### Changed
* Bumped bundle version
* Upgraded gem dependencies


## [4.0.0] - 2024/02/11
### Added
* Added specs
* Added exit functionality and 

### Changed
* Refactor the flow of the app and the interaction with the user
* Refactor the whole project code structure
* Refactored the 'user_input' method to handle invalid city inputs more effectively. 
* Enhanced error handling.


## [3.0.0] - 2023/12/31
### Changed
* Bumped Ruby version to 3.2.2 for project and also in Dockerfile


## [2.2.0] - 2023/12/05
### Added
* Added rubocop.yml config file

### Changed
* Applied some rubocop suggestions 
* Bumped some dependencies
* Refactor namings
* New blob gif


## [2.1.3] - 2023/06/21
### Changed
* byebug and httparty bumped versions


## [2.1.2] - 2022/01/23
### Added
* Console clearing before printing the games


## [2.1.1] - 2021/11/13
### Added

* Blank input to default to Berlin tz
### Changed
* SocketError to use Paint gem


## [2.1.0] - 2021/11/02
### Added
* Added prompt user input to select the city for timezone
* Added help input to show list of cities / timezones available
* Added Gemfile
* Added Dockerfile
* 
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
