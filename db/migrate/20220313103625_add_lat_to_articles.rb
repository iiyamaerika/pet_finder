class AddLatToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :lat, :float
  end
end
