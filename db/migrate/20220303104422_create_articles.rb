class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.integer :user_id, null: false
      t.integer :status, null: false, default: 0
      t.string :image
      t.string :title, null: false
      t.date :date, null: false
      t.string :prefecture, null: false
      t.string :place, null: false
      t.string :animal_type, null: false
      t.integer :animal_age, null: false
      t.integer :animal_sex, null: false, default: 0
      t.text :introduction, null: false

      t.timestamps
    end
  end
end
