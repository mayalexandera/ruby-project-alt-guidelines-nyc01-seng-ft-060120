class User < ActiveRecord::Base
  has_many :recipes
  has_many :meals

  def self.register_a_user
    puts "Okay, let's sign you up!"
    puts "What is your username?"
    name = gets.chomp

    puts "Okay, what's is your password?"
    pass = gets.chomp
    if User.find_by(name: name)
      puts "Sorry, a user with that Username exists."
    else
      User.create(name: name, password: pass)
    end
  end

  def self.login_a_user
    puts "What is your username?"
    name = gets.chomp
    pass = TTY::Prompt.new.mask("What is your password?")

    if User.find_by(name: name, password: pass)
      User.find_by(name: name, password: pass)
    else
      puts "Sorry, a user cannot be found."
    end
  end

  def update_username
    puts "Please enter your new username"
    username = gets.chomp
    self.update(name: username)
    puts "your username is now #{username}"
  end

  def create_recipe
    puts "Enter a name for a recipe"
    recipe_name = gets.chomp
    puts "How many servings are in this recipe?"
    servings = gets.chomp
    recipe_input = Recipe.create(name: recipe_name, user: self, servings: servings)
    recipe_input.add_recipe_to_meal
  end

  def list_recipes(recipes=self.recipes)
    recipes.map { |recipe| recipe.name }
  end

  def choose_recipe
    recipe = TTY::Prompt.new.enum_select("Please choose a recipe", self.list_recipes)
    self.recipes.find_by(name: recipe)
  end

  def edit_recipe
    choice = self.choose_recipe
    choice.edit
  end

  def delete_recipe
    recipe = self.choose_recipe
    recipe.destroy
    puts "deleted #{recipe.name}"
  end

  def all_recipes_read_update_delete
    system "clear"
    choice = self.choose_recipe
    self.read_update_delete(choice)
  end

  def add_recipe_to_meal
    recipe1 = self.choose_recipe
    recipe1.add_recipe_to_meal
  end

  def meals_by_name(name)
    meals = self.meals.find_all{ |meal| meal.name == name }
    RecipeMeal.connect_rms(name, meals, self)
  end
    
  def show_recipes_by_meal
    meals = self.meals.map { |meal| meal.name }.uniq
    choice = TTY::Prompt.new.enum_select("Please choose a meal category", meals)
    self.meals_by_name(choice)
  end

  def read_update_delete(choice)
    system "clear"
    puts "RECIPE: #{choice.name}  | SERVINGS: #{choice.servings}"
  TTY::Prompt.new.select("What would you like to do?") do |recipe|
    recipe.choice "See nutrition information", -> {
      choice.nutrient_totals
    }
    recipe.choice "edit", -> {
      system "clear"
      choice.edit
    }
    recipe.choice "see ingredients", -> {
      choice.show_ingredients
    }
    recipe.choice "delete recipe", -> {
      system "clear"
      choice.destroy
      puts "deleted #{choice.name}"
    }
  end
end

end
