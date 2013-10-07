require 'sinatra/base'

module Sinatra
    module Routes
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
        if File.exists? "#{settings.views}#{settings.styles}#{file}.sass"
          content_type 'text/css', :charset => 'utf-8'
          sass :"#{settings.styles}/#{file}"
        else redirect '/' end
      end

      get '/*.js' do |file|
        if File.exists? "#{settings.views}#{settings.scripts}#{file}.coffee"
          content_type 'text/javascript', :charset => 'utf-8'
          coffee :"#{settings.scripts}/#{file}"
        else redirect '/' end
      end
    end
    register Routes
end