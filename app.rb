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

class Blog < Sinatra::Application
  register Sinatra::Routes

  def setTitle title = "Blog"
    @title = title
  end

  def getItems # Get all posts
    Dir.glob settings.posts + "[^@]*.{md,markdown,mdown,txt,html,slim}"
  end

  def showPosts page = 0 # Show posts on page
    archive = getItems
    @all_posts = archive.count
    @pages = (@all_posts/settings.per_page).ceil
    posts = []
    for post in archive
      posts.push parse post
    end 
    posts
  end

  def parse post
    data = Hash.new
    data[:url] = File.basename(post).strip().sub(" ", "-")
    data[:time] = File.ctime post
    file = File.open(post).read().split "---metaend!\n"
    data[:meta] = YAML.load file[0]
    case File.extname post
      when /\.(md, markdown, mdown)/ then data[:content] = Town.parse file[1]
      when ".slim" then data[:content] = slim file[1]
      else data[:content] = file[1]
    end
    data[:content] = data[:content].sub "\n", '<br />'
    data
  end

  def showPages page
    #@pages
  end

end