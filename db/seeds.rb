user1 = User.create(name: "Lily")

recipe1 = Recipe.create(name: "Pumpkin Pie", user: user1)

ingredient1 = Ingredient.create(name: "pumpkin puree", recipe: recipe1)
ingredient2 = Ingredient.create(name: "flour", recipe: recipe1)

meal1 = Meal.create(name: "Breakfast", user: user1)

RecipeMeal.create(meal: meal1, recipe: recipe1)

