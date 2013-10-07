require 'rubygems'
require 'sinatra'
require 'slim'
require 'compass'
require 'town'
require 'coffee-script'

class Blog < Sinatra::Application
  # Routes:
  get '/?' do
    slim :index, :layout => true
  end

  get '/*.css' do |file|
    if File.exists? settings.views + 'styles/' + file + '.sass'
      content_type 'text/css', :charset => 'utf-8'
      sass :"styles/#{file}"
    else redirect '/'; end
  end

  get '/*.js' do |file|
    if File.exists? settings.views + 'scripts/' + file + '.coffee'
      content_type 'text/javascript', :charset => 'utf-8'
      coffee :"scripts/#{file}"
    else redirect '/'; end
  end
 
  # Methods:
  def setTitle title
    @title = title
  end

  def getItems
    Dir.glob %r{posts/[a-zA-Z0-9-_+.].md}
  end
end