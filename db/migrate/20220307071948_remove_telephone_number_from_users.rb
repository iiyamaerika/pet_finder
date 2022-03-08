class RemoveTelephoneNumberFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :telephone_number, :string
  end
end
