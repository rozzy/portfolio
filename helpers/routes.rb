module Methods
  def set_title title = "Blog"
    @title = title
  end

  def get_items # Get all posts
    Dir.glob settings.posts + "[^@]*.{md,markdown,mdown,txt,html,slim}"
  end

  def show_posts page = 0 # Show posts on page
    archive = get_items
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

  def show_pages page
    #@pages
  end
end