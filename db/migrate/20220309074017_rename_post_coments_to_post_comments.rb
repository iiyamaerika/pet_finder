class RenamePostComentsToPostComments < ActiveRecord::Migration[6.1]
  def up
    rename_table :post_coments, :post_comments
  end

  def down
    rename_table :post_comments, :post_coments
  end
end
