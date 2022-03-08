class AddAnimalAgeToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :animal_age, :string
  end
end
