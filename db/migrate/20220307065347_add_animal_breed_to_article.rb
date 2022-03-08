class AddAnimalBreedToArticle < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :animal_breed, :string
  end
end
