# encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'slim'
require 'compass'
require 'town'
require 'yaml'
require 'coffee-script'

configure do
  set :environment, :development
  
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "views/") }
  set :public_folder, Proc.new { File.join(root, "public") }
  
  set :styles, "styles/"
  set :scripts, "scripts/"
  set :posts, "posts/"
  set :helpers, "helpers/"
  set :per_page, 5
  set :show_full_post, true

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

Dir["#{settings.helpers}*.rb"].each {|file| require_relative settings.helpers + File.basename(file, ".rb")}

class Blog < Sinatra::Application
  include Methods

  get '/' do
    @page = 1
    slim :index, :layout => true
  end

  get '/', :provides => ['rss', 'atom', 'xml'] do
    builder :feed
  end

  get '/~(\d)' do |page|
    @page = page
    slim :index, :layout => true
  end

  get '/*.css' do |file|
    if File.exists? "#{settings.views+settings.styles+file}.sass"
      content_type 'text/css', :charset => 'utf-8'
      sass :"#{settings.styles}/#{file}"
    else redirect '/' end
  end

  get '/*.js' do |file|
    if File.exists? "#{settings.views+settings.scripts+file}.coffee"
      content_type 'text/javascript', :charset => 'utf-8'
      coffee :"#{settings.scripts}/#{file}"
    else redirect '/' end
  end
end