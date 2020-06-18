class Controller
  attr_accessor :user, :prompt

  def initialize
    @prompt = TTY::Prompt.new
  end

  def greetings
    puts "Welcome to Macro Tracker"
    prompt.select("What would you like to do?") do |menu|
      menu.choice "Register", -> { User.register_a_user }
      menu.choice "Login", -> { User.login_a_user }
    end
  end

  def main_menu
    system "clear"
    self.user.reload
    puts "Welcome, #{self.user.name}!"
    prompt.select ("What would you like to do?") do |menu|
      menu.choice "Create a new recipe", -> { self.create_recipe }
      menu.choice "See all my recipes", -> { self.show_recipes_by_name }
      menu.choice "See all my recipes by meal", -> { Meal.recipe_by_meal(@user) }
      menu.choice "Update User Info", -> { self.update_username }
    end
  end

  def create_recipe
    @user.create_recipe
    self.main_menu
  end

  def show_recipes_by_name
    if @user.recipes.count == 0
      TTY::Prompt.new.keypress("you have no recipes, press any key to continue", timeout: 30)
    else
      @user.show_recipes_by_name
    end
    self.main_menu
  end

  def show_recipes_by_meal
    if @user.recipes.count == 0
      TTY::Prompt.new.keypress("you have no recipes, press any key to continue", timeout: 30)
    else
      @user.show_recipes_by_meal
    end
    self.main_menu
  end

  def update_username
    @user.update_username
    self.main_menu
  end

  def edit_recipe
    @user.edit_recipe
    self.main_menu
  end
end

#ask if they would like to add another ingredient or finished

#if finished, prompt user for serving quantity, and return nutritional value for one serving

#add serving to meal
