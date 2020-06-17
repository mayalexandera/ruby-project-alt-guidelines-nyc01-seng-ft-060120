
require 'pry'
class Recipe < ActiveRecord::Base
  belongs_to :user

  has_many :recipe_meals
  has_many :meals, through: :recipe_meals

  has_many :ingredients

  def add_ingredient_to_recipe
    puts "Please enter the name of your ingredient"
    ingredient1 = gets.chomp

    url = "https://api.edamam.com/api/food-database/parser?ingr=#{ingredient1}&app_id=#{APP_ID}&app_key=#{APP_KEY}"

    restClientResponseObject = RestClient.get(url)

   #if restClientResponseObject["status"] == 'error'
   #   self.add_ingredient_to_recipe
   #end
    jsonButItsAString = restClientResponseObject.body
    workable_hash = JSON.parse(jsonButItsAString)
    nutrients1 = workable_hash["parsed"][0]["food"]["nutrients"]

    puts "How many grams does your recipe call for?"
    grams = gets.chomp.to_f

    calc_nutrients1 = nutrients1.transform_values{ |v| (v * (grams/100)).round(2) }
    calc_ingredient1 = Ingredient.create(name: ingredient1, recipe_id: self.id, calories: calc_nutrients1["ENERC_KCAL"], protein: calc_nutrients1["PROCNT"], fat: calc_nutrients1["FAT"], carbs: calc_nutrients1["CHOCDF"])
 
    answer = TTY::Prompt.new.select("what would you like to do?") do |recipe|
      recipe.choice "Add another ingredient", -> {self.add_ingredient_to_recipe}
      recipe.choice "See nutrient totals for recipe", -> {self.nutrient_totals}
    end
  end

  def nutrient_totals
    self.user.choose_recipe
    totals = {}
    totals["calories"] = self.ingredients.sum{ |ing| ing.calories}
    totals["protein"] = self.ingredients.sum{ |ing| ing.protein}
    totals["carbs"] = self.ingredients.sum{ |ing| ing.carbs}
    totals["fat"] = self.ingredients.sum{ |ing| ing.fat}

    puts "# of servings: #{self.servings}"
    
    puts "the nutrient totals for this recipe are:"
    puts "_________________________________________"
    totals.map { |nutrient, value| puts "#{nutrient}: #{value}" } 
    puts "                                         "
    puts "Here are the nutrients per serving"
    puts "_________________________________________"
    totals.map { |nutrient, value| puts "#{nutrient}: #{value/self.servings}"}
    puts "                                         "
    TTY::Prompt.new.keypress("Press any key to continue", timeout: 30)
  end

  def add_recipe_to_meal
    TTY::Prompt.new.select("What meal is recipe for?") do |recipe|
      recipe.choice "Breakfast", -> {
        meal = Meal.create(user: self.user, name: "Breakfast")
        recipe = RecipeMeal.create(meal: meal, recipe: self)
      }
      recipe.choice "Lunch", -> {
        meal = Meal.create(user: self.user, name: "Lunch")
        recipe = RecipeMeal.create(meal: meal, recipe: self)
      }
      recipe.choice "Dinner", -> {
        meal = Meal.create(user: self.user, name: "Dinner")
        recipe = RecipeMeal.create(meal: meal, recipe: self)
      }
    end
    self.show_meal_name

    #TTY::Prompt.new.keypress("Press any key to continue", timeout: 30)

  end

  def edit_recipe
    TTY::Prompt.new.select("What would you like to edit") do |recipe|
      recipe.choice "Servings: ", -> {
        puts "enter new value"
        val = gets.chomp
        self.update(servings: val)
      }
      recipe.choice "Ingredients: ", ->{
        puts "enter new value"
        val = gets.chomp
        self.update(ingredients:val)
      }
      recipe.choice "Name: ", ->{
        puts "enter new value"
        val = gets.chomp
        self.update(name: val)
      }
    end
    self.user.show_recipes_by_name
  end

  def show_meal_name
    meal_id = self.recipe_meals.last.meal_id
    meal = Meal.all.find_by(id: meal_id)
    puts "You assigned #{self.name} to your #{meal.name} meals"
    self.add_ingredient_to_recipe
  end

end

