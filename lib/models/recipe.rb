
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
    nutrient_response = workable_hash["parsed"][0]["food"]["nutrients"]

    puts "How many grams does your recipe call for?"
    grams = gets.chomp.to_f

    nutrients = self.calculate_nutrients(nutrient_response, grams)
    self.calculate_ingredient(ingredient1, nutrients, grams)

    TTY::Prompt.new.select("what would you like to do?") do |recipe|
      recipe.choice "Add another ingredient", -> {self.add_ingredient_to_recipe}
      recipe.choice "See nutrient totals for recipe", -> {self.nutrient_totals}
    end
  end

  def calculate_nutrients(nutrient_response, grams)
    nutrient_response.transform_values{ |v| (v * (grams/100)).round(2) }
  end

  def calculate_ingredient(name, nutrients, grams)
    Ingredient.create(name: name, recipe_id: self.id, grams: grams, calories: nutrients["ENERC_KCAL"], protein: nutrients["PROCNT"], fat: nutrients["FAT"], carbs: nutrients["CHOCDF"])
  end

  def delete_ingredient
    to_delete = self.choose_ingredient
    self.ingredients.destroy(to_delete)
    puts "#{to_delete.name} has been deleted!"
    self.show_ingredients
  end

  def list_ingredients
    self.ingredients.map{ |ing| ing.name }
  end

  def choose_ingredient
    ing_names = self.list_ingredients
    TTY::Prompt.new.enum_select("select an ingredient", ing_names)
  end

  def nutrient_totals
    system "clear"
    totals = {}
    totals["calories"] = self.ingredients.sum{ |ing| ing.calories}
    totals["protein"] = self.ingredients.sum{ |ing| ing.protein}
    totals["carbs"] = self.ingredients.sum{ |ing| ing.carbs}
    totals["fat"] = self.ingredients.sum{ |ing| ing.fat}
    totals["grams"] = self.ingredients.sum{ |ing| ing.grams}

    puts "RECIPE: #{self.name}  |  SERVINGS: #{self.servings}"
    puts "                                                             "
    puts "RECIPE TOTAL NUTRIENTS:"
    totals.map do |nutrient, value| 
      puts "#{nutrient}: #{value} grams" if nutrient != "calories" 
      puts "#{nutrient}: #{value} "if nutrient === "calories" 
    end
    puts "                                         "
    puts "NUTRIENTS PER SERVING:"
    totals.map do |nutrient, value| 
      puts "#{nutrient}: #{value/self.servings} grams" if nutrient != "calories" 
      puts "#{nutrient}: #{value/self.servings} "if nutrient === "calories" 
    end
    puts "                                         "
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

  def edit
    TTY::Prompt.new.select("What would you like to edit?") do |recipe|
      recipe.choice "servings: ", -> {
        puts "enter new value for servings"
        val = gets.chomp
        self.update(servings: val)
        self.nutrient_totals
      }
      recipe.choice "ingredients: ", -> { self.edit_ingredients}
      recipe.choice "name: ", ->{
        puts "enter new name for your recipe"
        val = gets.chomp
        self.update(name: val)
        "recipe name changed to #{self.name}"
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
    self.ingredients.map {|ing| puts "#{ing.name}: #{ing.grams} grams" }
  end

  

end

