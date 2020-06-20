class RecipeMeal < ActiveRecord::Base
  belongs_to :meal
  belongs_to :recipe

  def self.connect_rms(name, meals, user)
    system "clear"
    meal_ids = meals.map { |meal| meal.id }
    rms_by_meal = RecipeMeal.where(:meal_id => meal_ids)
    rms_by_meal_ids = rms_by_meal.map { |rms| rms.meal_id }
    recipes = user.recipes.where(:id => rms_by_meal_ids)
    puts "Here are all your #{name} recipes"
    choice = TTY::Prompt.new.enum_select("Select a recipe", user.list_recipes(recipes))
    rec = user.recipes.find_by(name: choice)
    user.read_update_delete(rec)
  end
end
