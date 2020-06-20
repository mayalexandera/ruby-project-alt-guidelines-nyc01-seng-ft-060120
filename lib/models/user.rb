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

  def create_recipe
    puts "Enter a name for a recipe"
    recipe_name = gets.chomp
    puts "How many servings are in this recipe?"
    servings = gets.chomp
    recipe_input = Recipe.create(name: recipe_name, user: self, servings: servings)
    recipe_input.add_recipe_to_meal
  end

  def update_username
    puts "Please enter your new username"
    username = gets.chomp
    self.update(name: username)
    puts "your username is now #{username}"
  end

  def recipes_read_edit_delete
    self.list_recipes
    TTY::Prompt.new.select("What would you like to do?") do |recipe|
      recipe.choice "See nutrient totals for a recipe", -> {
        recipe = self.choose_recipe
        recipe.nutrient_totals
      }
      recipe.choice "edit recipe", -> {
        system "clear"
        self.recipe_edit
      }
      recipe.choice "see ingredients for recipe", -> {
        recipe = self.choose_recipe
        recipe.show_ingredients
      }
      recipe.choice "delete a recipe", -> {
        system "clear"
        self.delete_recipe
      }
    end
  end

  def list_recipes
    return recipes.map{ |recipe| recipe.name } 
  end

  def add_recipe_to_meal
    recipe1 = self.choose_recipe
    recipe1.add_recipe_to_meal
  end

  def choose_recipe
    recipe = TTY::Prompt.new.enum_select("Please choose a recipe", self.list_recipes)
    self.recipes.find_by(name: recipe)
  end

  def recipe_edit
    choice = self.choose_recipe
    choice.edit_recipe
  end

  def delete_recipe
    recipe = self.choose_recipe
    recipe.destroy
    puts "deleted #{recipe.name}"
  end
end
