###############################################
# Rails3 application template
###############################################

repo_url = "https://raw.github.com/ryoo/rails3_template/master"
gems = {}

@app_name = app_name


# gems
#-------------------

## Database

if yes?("Would you like to use mysql?")
  gem 'mysql2'
end

if yes?("Would you like to use heroku?")
group :production do
  gem 'pg'
end

# soft delete
gem 'permanent_records'

## Dev env

gem_group :development do
  gem 'pry-rails'
end

# coloring log
gem 'rainbow'

# print reciever object
gem 'tapp'

# right cli to execute rails command
gem 'rails-sh', require: false


## Configuration

gem 'rails_config'


##View elements

# pagination
gem 'kaminari'


## Utility

# xml-sitemap
#if yes?("Would you like to install xml-sitemap?")
gem 'xml-sitemap'
#end

# cron mangement
if yes?("Would you like to install whenever?")
  gem 'whenever', require: false
end

# nokogiri html parser to scrape
if yes?("Would you like to install nokogiri?")
  gem 'nokogiri'
end


# Bundle install
#-----------------------------------------

run "bundle install"


# Configuration
#-----------------------------------------

remove_file "public/index.html"

# timzone setting
gsub_file 'config/application.rb', /"# config.time_zone = 'Central Time (US & Canada)'"/, "config.time_zone = 'Tokyo'"

# database.yml configuration
@mysql = false
if yes?("Set up mysql now?")
  @mysql = {}
  @mysql[:dev_db] = ask("database name on dev?")
  @mysql[:dev_un] = ask("user_name on dev?")
end

if @mysql
  remove_file "config/database.yml"
  get "#{repo_url}/config/database.yml", 'config/database.yml'
  gsub_database 'config/database.yml'
end

def gsub_database(localpath)
  return unless @mysql

  gsub_file localpath, /%dev_db%/, @mysql[:dev_db] ? @mysql[:dev_db] : @app_name
  gsub_file localpath, /%dev_un%/, @mysql[:dev_un]
  gsub_file localpath, /%app_name%/, @app_name
end

# Generators
#-----------------------------------------

if gems[:bootstrap]
  generate 'bootstrap:install'

  if yes?("Would you like to create FIXED layout?(yes=FIXED, no-FLUID)")
    generate 'bootstrap:layout application fixed'
  else
    generate 'bootstrap:layout application fluid'
  end

  gsub_file "app/views/layouts/application.html.haml", /lang="en"/, %(lang="ja")
end


# Git
#-----------------------------------------

git :init
git :add => '.'
git :commit => '-am "Initial commit"'
