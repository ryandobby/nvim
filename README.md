# nvim

## Installation

###### Install neovim

```bash
// if you you need python3 for some reason
$ sudo apt-get install python-dev python-pip python3-dev python3-pip

$ sudo add-apt-repository ppa:neovim-ppa/stable
$ sudo apt-get update && sudo apt upgrade -y
$ sudo apt-get install neovim -y

// clone this repo
$ git clone git@github.com:ryandobby/nvim.git
$ mv nvim ~/.config/
```
#### Optional PHP Configuration

###### Install PHP

```bash
$ sudo add-apt-repository ppa:ondrej/php
$ sudo apt update && sudo apt upgrade -y
$ sudo apt install php7.2 libapache2-mod-php7.2 php7.2-mysql php7.2-mbstring php7.2-common php7.2-xml php7.2-json php7.2-curl php7.2-zip
$ sudo apt update && sudo apt upgrade -y
```

###### Install Composer

```bash
$ mkdir -p /usr/local/bin 
$ sudo apt install composer -y
$ wget https://getcomposer.org/download/1.8.4/composer.phar
$ sudo mv composer.phar /usr/local/bin/
```

###### Composer packages

```bash
$ composer global require phpmd/phpmd
$ composer global require squizlabs/php_codesniffer
$ composer global require friendsofphp/php-cs-fixer

// For non laravel projects
$ composer global require phpstan/phpstan

// For laravel projects
$ composer global require nunomaduro/larastan
```

## Configuration

```
// Ignore the errors by pressing enter at the prompts
$ nvim

// To install all of the plugins
:PlugInstall

// exit nvim to apply plugin changes and then launch it again
:q

$ nvim
// To open the init.vim, which is neovim's version of .vimrc
// The comma is the <Leader> key that we defined, default is \
,ev
```

## Credits
[Inspiration for Laravel neovim setup](https://kushellig.de/neovim-php-ide/) - kushellig
