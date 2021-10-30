# Football NOW

Prints to the console the next football matches on Portuguese TV Channels but on GTM +2 for CEST

Shutout to [zerozero](https://www.zerozero.pt/rss/zapping.php) for providing the rss list

![Demo gif](https://github.com/wmanica/football_now/blob/master/blob/preview.gif)

## Setup

1) install ruby v3.0.2. Check [rbenv](https://github.com/rbenv/rbenv) for more info

2) install the required gems
```
gem install httparty activesupport paint
```

## Usage

in the project folder
```
ruby football_now.rb
```
NOTE: If you wish to run this command shortly (as shown in the gif above) you can set it up in your shell config. In my case ~/.zshrc and add method with the input name you desire, in my case tv, which would like this:
```
##### FOOTBALL NOW #####
	tv() {
		clear
		ruby ~/PATH/TO/THE/PROJECT/FOLDER/football_now/football_now.rb
	}
```

## About

Ruby 3.0.2

## Versions

Current version: **2.0.2**

## Changelog

The changelog can be found [here](changelog.md).
