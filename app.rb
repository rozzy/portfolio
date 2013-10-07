# app.rb

class Blog < Sinatra::Application
  # Routes:
  get '/?' do
    @page = 1
    slim :index, :layout => true
  end

  get '/~(\d)' do |page|
    @page = page
    slim :index, :layout => true
  end

  get '/', :provides => ['rss', 'atom', 'xml'] do
    builder :feed
  end

  get '/*.css' do |file|
    if File.exists? settings.views + settings.styles + file + '.sass'
      content_type 'text/css', :charset => 'utf-8'
      sass :"#{settings.styles}/#{file}"
    else redirect '/'; end
  end

  get '/*.js' do |file|
    if File.exists? settings.views + settings.scripts + file + '.coffee'
      content_type 'text/javascript', :charset => 'utf-8'
      coffee :"#{settings.scripts}/#{file}"
    else redirect '/'; end
  end
 
  # Methods:
  def setTitle title = "Blog"
    @title = title
  end

  def getItems # Get all posts
    Dir.glob settings.posts + "/[^@]*.{md,markdown,mdown,txt,html,slim}"
  end

  def showPosts page = 0 # Show posts on page
    posts = getItems
    @all_posts = posts.count
    @pages = (@all_posts/settings.per_page).ceil

  end

  def showPages page
    #@pages
  end

end