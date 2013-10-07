require 'rubygems'
require 'sinatra'
require 'slim'
require 'compass'
require 'town'
require 'yaml'
require 'coffee-script'
require "./app"

configure do
  set :environment, :development
  
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "views/") }
  set :public_folder, Proc.new { File.join(root, "public") }
  
  set :styles, "styles/"
  set :scripts, "scripts/"
  set :posts, "posts/"
  set :per_page, 5
  set :show_full_post, true
  set :helpers, "/helpers/"
  
  Dir[settings.helpers+"*.rb"].each {|file| require file if file.exists? }

  Slim::Engine.set_default_options pretty: (settings.environment == :development ? true : false), sort_attrs: true

  Compass.configuration do |config|
    settings.environment == :production ? 
      config.output_style = :compressed : 
      config.output_style = :nested
    settings.environment == :development ?
      config.line_comments = true :
      config.line_comments = false
  end

  set :sass, Compass.sass_engine_options
end

run Blog