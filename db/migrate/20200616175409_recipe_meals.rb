class RecipeMeals < ActiveRecord::Migration[5.2]
  def change
    create_table :recipe_meals do |t|
      t.integer :recipe_id
      t.integer :meal_id
    end
  end
end
