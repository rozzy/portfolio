module Pagination
  def set_page num
    @page = num
    @archive = get_items
    @all_posts = @archive.count
    @pages = @all_posts/settings.per_page.to_f
    p @pages.ceil
  end
end