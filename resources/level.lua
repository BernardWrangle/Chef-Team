--[[
Levels will be set up here. Game will call the level, and the level
(this) will call an external file (xml?) to determine these things:
1: Recipe name
2: List of actual ingredients to load
3: List of dummy ingredients
4: Level stats (time needed to win, accuracy needed to win and
presentation needed to win, chef stuff?, and anything I'm forgetting)
External files will needed to be named sequentially, for example
level_1, level_2, level_3 etc.. and we will iterate through those files
as the player beats levels and progresses. 
There will need to be a loops that increments the level number and calls
the apporopriate level file when the player beats a level and moves on
to the next.
--]]

module(..., package.seeall)

-- OO functions
require("class")
require("game")

-- Global vars
name		= ""		-- name of level
recipes		= {}		-- pool of ingredients
pantryIngredients = {}	-- ingredients to include in pantry (pulled from recipes)


-- Level
level = inheritsFrom(baseClass)

--[[
A level consists of:
-Level name, as define in level_x.txt 
-recipes, as defined in level_x.txt
-ingredients, pulled from recipe.ingredients[] object--]]
function New(levelName, recipes, ingredients)
	name = levelName

	--This loop creates an array of strings which will be our Ingredient/TextObject IDs
	local pantryIngredients= {}
	--[[!!!!!*****UNCOMMENT ONCE RECIPE CLASS IS CREATED
	for i, v in ipairs(recipe.ingredients) do
		actualIngredients[key] = ingredients
	end
	!!!!!*****--]]
end

--[[init()- called from game.init(). Game controls the current level
in game.levelIndex and send it here so we know which level_x.txt
file to open. Then e open our txt file for the level and assigned the values
to temp vars, then we call New() to assign the globals and
generate the list of ingredients for the level
--]]
function init(levelIndex)
	local value1, value2 = ""
	local tempArray = {}
	local index = 1
	local lvlName = ""
	local ingIndex = 1  -- Used to index in loading ingredients loop
	local recipeArray = {} -- Used to hold our recipes list
	local recipeIndex = 1 -- Used to assign recipes to our recipeArray

	-- Open the file
	local file = io.open("level_" .. levelIndex .. ".txt", "r")
	if not file then
		name="error"
		return false
	end
	
	-- Read the lines in the file
	for line in io.lines("level_" .. levelIndex .. ".txt") do
		-- First, we place each value in the line into our array
		for value in string.gmatch(line, '([^,]+)') do
			tempArray[index] = value -- Add each value as an index
			index = index + 1 -- Increment our index
		end
		
		-- Evaluate first value in string, make decisions from there
		if tempArray[1] == "name" then
			lvlName = tempArray[2]
		end

		if tempArray[1] == "recipe" then
			recipeArray[recipeIndex] = tempArray[2]
			recipeIndex = recipeIndex + 1
		end

		index = 0 -- recset our index to 0 to evaluate the next line
	end
	New(lvlName)
end