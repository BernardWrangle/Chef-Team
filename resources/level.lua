--[[
Levels will be set up here. Game will call the level, and the level
(this) will call an external file to determine these things:
1: Name of level
2: Recipes included in the level
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
function New(levelName, recipeArray)
	name = levelName

	--Initialize recipes in level
	for key, value in pairs(recipeArray) do
		recipe.init(value)
	end
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
	local file = io.open("levels/level_" .. levelIndex .. ".txt", "r")
	if not file then
		name="error"
		return false
	end
	
	-- Read the lines in the file
	for line in io.lines("levels/level_" .. levelIndex .. ".txt") do
		-- First, we place each value in the line into our array
		for value in string.gmatch(line, '([^,]+)') do
			tempArray[index] = value -- Add each value to temp array
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
		
		index = 1 -- reset our index to 0 to evaluate the next line
	end
	New(lvlName,recipeArray)
end