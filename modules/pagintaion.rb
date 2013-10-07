module Pagination
  def set_page num
    @page = num == 0 ? 1 : num
    @archive = get_items
    @all_posts = @archive.count
    @pages_num = count_pages
    redirect '/' if @page > @pages_num
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