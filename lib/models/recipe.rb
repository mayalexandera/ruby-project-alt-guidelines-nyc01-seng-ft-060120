
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
    jsonButItsAString = restClientResponseObject.body
    workable_hash = JSON.parse(jsonButItsAString)
    nutrients1 = workable_hash["parsed"][0]["food"]["nutrients"]

    puts "How many grams does your recipe call for?"
    grams = gets.chomp.to_f

    calc_nutrients1 = nutrients1.transform_values{ |v| (v * (grams/100)).round(2) }
    calc_ingredient1 = Ingredient.create(name: ingredient1.capitalize, recipe_id: self.id, calories: calc_nutrients1["ENERC_KCAL"], protein: calc_nutrients1["PROCNT"], fat: calc_nutrients1["FAT"], carbs: calc_nutrients1["CHOCDF"])
 
    TTY::Prompt.new.select("what would you like to do?") do |recipe|
      recipe.choice "Add another ingredient", -> {self.add_ingredient_to_recipe}
      recipe.choice "See nutrient totals for recipe", -> {self.nutrient_totals}
    end
  end

  def delete_ingredient
    ingredient_names = self.ingredients.map{ |ing| ing.name }
    ing_name = TTY::Prompt.new.enum_select("select an ingredient to delete", ingredient_names)
    to_delete = self.ingredients.find_by(name: ing_name)
    self.ingredients.destroy(to_delete)
    puts "#{to_delete.name} has been deleted!"
    TTY::Prompt.new.keypress("Press any key to continue", timeout: 30)
    self.show_ingredients
    TTY::Prompt.new.keypress("Press any key to return to main menu", timeout: 30)
  end

  def nutrient_totals
    totals = {}
    totals["calories"] = self.ingredients.sum{ |ing| ing.calories}
    totals["protein"] = self.ingredients.sum{ |ing| ing.protein}
    totals["carbs"] = self.ingredients.sum{ |ing| ing.carbs}
    totals["fat"] = self.ingredients.sum{ |ing| ing.fat}

    puts "RECIPE: #{self.name}  |  SERVINGS: #{self.servings}"
    puts "                                                             "
    puts "RECIPE TOTAL NUTRIENTS:"
    totals.map { |nutrient, value| puts "#{nutrient}: #{value}" } 
    puts "                                         "
    puts "NUTRIENTS PER SERVING:"
    totals.map { |nutrient, value| puts "#{nutrient}: #{value/self.servings}"}
    puts "                                         "
    TTY::Prompt.new.keypress("Press any key to return to main menu", timeout: 30)
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
  end

  def recipes_by_meal
    @user.recipes
  end 

  def edit_recipe
    TTY::Prompt.new.select("What would you like to edit?") do |recipe|
      recipe.choice "servings: ", -> {
        puts "enter new value for servings"
        val = gets.chomp
        self.update(servings: val)
      }
      recipe.choice "ingredients: ", -> { self.edit_ingredients}
      recipe.choice "name: ", ->{
        puts "enter new recipe name"
        val = gets.chomp
        self.update(name: val)
      }
    end
  end

  def edit_ingredients
    TTY::Prompt.new.select("What would you like to do?") do |ing|
      ing.choice "add an ingredient", -> { self.add_ingredient_to_recipe }
      ing.choice "delete an ingredient", -> { self.delete_ingredient }
    end
  end

  def show_meal_name
    meal = Meal.all.find_by(id: self.recipe_meals.last.meal_id)
    puts "You assigned #{self.name} to your #{meal.name} meals"
    self.add_ingredient_to_recipe
  end

  def show_ingredients
    puts "here are the ingredients for #{self.name}: "
    self.ingredients.map {|ing| puts ing.name }
  end


end

