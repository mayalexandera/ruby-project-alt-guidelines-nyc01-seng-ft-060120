class Meal < ActiveRecord::Base
  belongs_to :user
  
  has_many :recipe_meals
  has_many :recipes, through: :recipe_meals

  #def show_recipes_by_meal
  #  rm_recipe_id = RecipeMeal.all.map { |rm| rm.recipe_id if rm.meal_id == self.id}
  #  rm = Recipe.all.map { |rec| rec.name if rec.id == rm_recipe_id}
  #  puts rm
#
  #  #meals_by_name.map{ |meal| meal.recipe_meals.recipe_id }
  #end

end