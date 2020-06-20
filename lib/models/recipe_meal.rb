class RecipeMeal < ActiveRecord::Base
  belongs_to :meal
  belongs_to :recipe

  def self.connect_rms(meals)
    meal_ids = meals.map { |meal| meal.id }
    rms_by_meal = RecipeMeal.where(:meal_id => meal_ids)
    rms_by_meal_ids = rms_by_meal.map { |rms| rms.meal_id }
  end
end
