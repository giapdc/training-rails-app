json.categories @categories, partial: "api/v1/categories/category", as: :category

json.meta do
  json.current_page @categories.current_page
  json.total_pages @categories.total_pages
  json.total_count @categories.total_count
end
