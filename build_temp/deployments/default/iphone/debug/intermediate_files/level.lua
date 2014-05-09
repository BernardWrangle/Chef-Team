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
--require("class")
require("ingredient")

-- Global vars
name				= ""	-- Name of level
recipes				= {}	-- Pool of recipes
recipeCount			= 1		-- Number of recipes in this level (always at least 1)
produceIng			= {}	-- Ingredients to include in produce+grains pantry (pulled from recipes)
herbIng				= {}	-- Ingredients to include in herb+spice pantry
meatIng				= {}	-- Ingredients to include in meat+dairy pantry
activeRecipe		= nil	-- Active recipe
background			= nil	-- Background image for level
ingredientRows		= 3		-- Total rows in pantry, will always be 3
ingredientColumns	= 0		-- Total columns in pantry grid (test value of 4 right now, later will be expanded)
ingredients			= {}
ingredientCount		= 0		-- Counts total number of ingredients in level
herbCount			= 0		-- Counts total number of herb ingredients in level
produceCount		= 0		-- Counts total number of produce ingredients in level
meatCount			= 0		-- Counts total number of meat ingredients in level

-- Level
level = inheritsFrom("game")

--[[
A level consists of:
-Level name, as define in level_x.txt 
-recipes, as defined in level_x.txt
-ingredients, pulled from recipe.ingredients[] object--]]
function New(levelName, recipeArray)
	name = levelName
	background = levelName .. "_BG"
	print(name)
	--Initialize recipes in level
	for key, value in pairs(recipeArray) do
		recipe.init(value)
		recipes[key] = recipe -- an array of all recipe objects in level
		game.recipes[key] = recipes[key]
		--TESTprint("key=" .. key)
		print(key)
		print(recipe.name)
		print(recipes[key].name .. "WTF")
		-- Initialize lists of ingredient types
		for i, j in pairs(recipes[key].ingredients) do
			local type = recipes[key].ingredientType[i]
			--TESTprint("value=" .. j .. " type=" .. type)   -- tesing to see if objects are correct
			
			if type == "produce" then
				--TESTprint("Inserting ingredient " .. j .. " into Produce array")
				produceIng[produceCount] = j   -- add ingredient to list
				produceCount = produceCount + 1
			elseif type == "herb" then
				herbIng[herbCount] = j
				herbCount = herbCount + 1
			elseif type == "meat" then
				meatIng[meatCount] = j
				meatCount = meatCount + 1
			end
		end
	end
	ingredientCount = meatCount + produceCount + herbCount
	activeRecipe = recipes[1] --[[*TODO***********************************
							  *    This will be changed. There should    *
							  *     be a function that sets the          *
							  *	   activeRecipe when the player clicks   *
							  *	   a ticket. Also, when a level starts   *
							  *	   there will be no active recipe        *
							  ***********************************TODO*--]]
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
		print("error, recipe file not found name = levels/level_" .. levelIndex .. ".txt")
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
		
		elseif tempArray[1] == "recipe" then
			recipeArray[recipeCount] = tempArray[2]
			recipeCount = recipeCount + 1
		
		elseif tempArray[1] == "background" then
			background = tempArray[2]
		end

		index = 1 -- reset our index to 0 to evaluate the next line
	end
	New(lvlName,recipeArray)
end