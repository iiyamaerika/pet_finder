class AddLngToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :lng, :float
  end
end
