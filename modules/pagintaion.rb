module Pagination
  def set_page num
    @page = num
    @archive = get_items
    @all_posts = @archive.count
    @pages_num = count_pages
    @actual_pages = trim_posts
  end

  def count_pages
    @pages = @all_posts/settings.per_page.to_f
    @pages.ceil
  end

  def trim_posts
    @archive.shift (@page-1)*settings.per_page.to_f
    @archive.pop @pages_num-@page.to_i
    @archive
  end
end

# 7 posts
# 1p: 3posts
# 2p: 3posts  <--- here || begin: (@page-1)*@per_page; end: (@all_pages-@page)*@per_page
# 3p: 1posts