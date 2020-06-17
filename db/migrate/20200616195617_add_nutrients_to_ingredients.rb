class AddNutrientsToIngredients < ActiveRecord::Migration[5.2]
  def change
    add_column :ingredients, :calories, :integer
    add_column :ingredients, :protein, :integer
    add_column :ingredients, :fat, :integer
    add_column :ingredients, :carbs, :integer
  end
end
