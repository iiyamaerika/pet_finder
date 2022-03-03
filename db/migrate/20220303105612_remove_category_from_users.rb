class RemoveCategoryFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :category, :integer
  end
end
