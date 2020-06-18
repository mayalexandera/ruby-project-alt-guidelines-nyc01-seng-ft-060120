class Meal < ActiveRecord::Base
  belongs_to :user
  
  has_many :recipe_meals
  has_many :recipes, through: :recipe_meals

end