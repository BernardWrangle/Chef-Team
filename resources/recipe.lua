--[[ Recipes
Attributes
name
type
ingredients
--]]

module(..., package.seeall)

-- OO functions
require("class")
require("game")
require("level")

-- Globals
name		=	""	--recipe name
recipeType	=	""	--type of recipe
ingredients	=	{}	--ingredients in recipe
ingredientType =	{} --either produceG,herbsSp,meatD (meat+dairy)
quantity	=	{}	--this applies to the amount of each ingredient and is always the same index as the ingredient it relates to. So quantity[5] refers to the amount of ingredient[5] in the recipe
price		=	""	--base price earned from recipe
cookTime	=	""	--time in seconds it take to prepare recipe

-- Recipe
recipe = inheritsFrom(baseClass)

--[[Called by level, this opens up the correct recipe file
-the file should be name "(recipe-name).txt" and it should
-inlude the ingredients in the recipe, base the dollar amount -earned from cooking the recipe, the type of recipe and the
-ingredients in the recipe
--]]
function init(recipeName)
	name = recipeName
	local tempArray = {}
	local index = 1
	local ingredientIndex = 1
	
	
	local file = io.open("recipes/" .. name .. ".txt", "r")
	if not file then
		print("error, recipe file not found name = recipes/" .. name .. ".txt")
		return false
	end
	
	--read the lines of the file
	for line in io.lines(name .. ".txt") do
		for value in string.gmatch(line, '([^,]+)') do
			tempArray[index] = value
			index = index + 1 
		end
		
		-- Evaluate first string
		if tempArray[1] == "name" then
			name = tempArray[2]
		end
		
		if tempArray[1] == "type" then
			recipeType = tempArray[2]
		end
		
		if tempArray[1] == "ingredient" then
			ingredients[ingredientIndex] = tempArray[2]
			quantity[ingredientIndex] = tempArray[3]
			ingredientType[ingredientIndex] = tempArray[4]
			ingredientIndex = ingredientIndex + 1
		end
		
		if tempArray[1] == "price" then
			price = tempArray[2]
		end
		
		if tempArray[1] == "time" then
			cookTime = tempArray[2]
		end
		
		index = 0 -- reset index before next line
	end
end

