user1 = User.create(name: "Lily")

recipe1 = Recipe.create(name: "Pumpkin Pie", user: user1)

ingredient1 = Ingredient.create(name: "pumpkin puree", recipe: recipe1, calories: 111 , protein: 34, fat: 3, carbs: 44, grams:3444 )
ingredient2 = Ingredient.create(name: "flour", recipe: recipe1, calories: 111, protein: 24, fat:44 , carbs: 23, grams:3433 )

meal1 = Meal.create(name: "Breakfast", user: user1)

RecipeMeal.create(meal: meal1, recipe: recipe1)

