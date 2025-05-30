# Football NOW

Prints to the console a list fo the next sports events on the Portuguese TV Channels. Now with user input prompt.

Shutout to [zerozero](https://www.zerozero.pt/rss/zapping.php) for providing the rss list

![Demo gif](https://github.com/wmanica/football_now/blob/master/blob/preview.gif)

## Setup
There is the possibility of installing ruby and the dependencies (you can also use a package manager like bundler), or
to use a containerized version with docker.

### Local
1) install ruby v3.4.3 - Check [rbenv](https://github.com/rbenv/rbenv) for more info

2) install the required gems
```
$ gem install activesupport httparty nokogiri paint rake
```
NOTE: alternatively if you use bundler, at the app directory:
```
$ bundler
```

### Docker container
You need to have docker installed and running in your machine first. Then in the project main directory:

1) Build the image
```
$ docker build . -t <container_name>:<version_tag>
```
2) Run the container
```
$ docker run -it <container_name>:<version_tag>
```

## Usage

in the project folder
```
bundle exec rake start:football_now
```
NOTE: If you wish to run this command shortly (as shown in the gif above) you can set it up in your shell config. In my case ~/.zshrc and add method with the input name you desire, in my case tv, which would like this:
```
##### FOOTBALL NOW #####
	tv() {
		clear
		BUNDLE_GEMFILE=~/PATH/TO/THE/PROJECT/FOLDER/football_now/Gemfile bundle exec rake -f ~/PATH/TO/THE/PROJECT/FOLDER/football_now/Rakefile start:football_now 
	}
```

## About

Ruby 3.4.3

## Versions

Current version: **6.0.0**

## Changelog

The changelog can be found [here](changelog.md).
