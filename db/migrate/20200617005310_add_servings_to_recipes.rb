class AddServingsToRecipes < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :servings, :integer
  end
end
