class RecipeMeal < ActiveRecord::Base
  belongs_to :meal
  belongs_to :recipe

  #def self.recipe_by_meal(user)
  #  meal_ids = user.meals.map{ |meal| meal.name if meal.id }
  #  recipe_ids = user.recipes.map { |rec| rec.id }
  #  puts meal_ids
  #  puts recipe_ids
  #  RecipeMeal.select{ |rec_me| recipe_ids.includes?(rec_me.recipe_id) &&
  #    meal_ids.includes?(rec_me.meal_id) }
  #end
end