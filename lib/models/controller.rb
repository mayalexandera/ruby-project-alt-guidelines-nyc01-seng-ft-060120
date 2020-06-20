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
      menu.choice "See all my recipes", -> { self.see_all_recipes }
      menu.choice "Update User Info", -> { self.update_username }
      menu.choice "Exit", -> { exit }
      #menu.choice "See all my recipes by meal", -> { Meal.recipe_by_meal(@user) }
    end
  end

  def create_recipe
    @user.create_recipe
    self.enter
  end

  def see_all_recipes
    if @user.recipes.count == 0
      TTY::Prompt.new.keypress("you have no recipes, press any key to continue", timeout: 30)
    else
      @user.recipes_read_edit_delete
    end
    self.enter
  end

  def enter
    TTY::Prompt.new.keypress("press any key to continue", timeout: 30)
    self.main_menu
  end

  def show_recipes_by_meal
    if @user.recipes.count == 0
      TTY::Prompt.new.keypress("you have no recipes, press any key to continue", timeout: 30)
    else
      @user.show_recipes_by_meal
    end
    self.enter
  end

  def update_username
    @user.update_username
    self.enter
  end

  def edit_recipe
    @user.edit_recipe
    self.enter
  end
end
