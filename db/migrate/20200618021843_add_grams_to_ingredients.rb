class AddGramsToIngredients < ActiveRecord::Migration[5.2]
  def change
    add_column :ingredients, :grams, :integer
  end
end
