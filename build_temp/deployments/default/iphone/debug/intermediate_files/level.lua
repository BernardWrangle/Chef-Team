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
require("ingredient")
require("game")

-- Global vars
name				= ""	-- Name of level
recipes				= {}	-- Pool of recipes
produceIng			= {}	-- Ingredients to include in produce+grains pantry (pulled from recipes)
herbIng				= {}	-- Ingredients to include in herb+spice pantry
meatIng				= {}	-- Ingredients to include in meat+dairy pantry
activeRecipe		= ""	-- Name of the active recipe. Active recipe is one that has it's quantities in the bottom section
background			= nil	-- Background image for level
ingredientRows		= 3		-- Total rows in pantry, will always be 3
ingredientColumns	= 0		-- Total columns in pantry grid (test value of 4 right now, later will be expanded)
ingredients			= {}
ingredientCount		= 0		-- Counts total number of ingredients in level
herbCount			= 0		-- Counts total number of herb ingredients in level
produceCount		= 0		-- Counts total number of produce ingredients in level
meatCount			= 0		-- Counts total number of meat ingredients in level

-- Local
local ingredientsGrid		-- Grid of ingredients
local prepContainerGrid		-- Grid of preperation containers

-- Level
level = inheritsFrom(baseClass)

--[[function LoadPantry(type)
	print("!ENTERED LOAD PANTRY!")
	local ingredientXPos = 32 -- starting position of ingredients in pantry row
	local ingredientYPos = 300
	local Xbuffer = 64
	local Ybuffer = 76
	local tempList = {""}		-- Use this to keep track of loaded assets, if already in this list, then it's already been loaded
	local tempIndex = 1
	local rowCount = 0
	local loaded = false
	local tempArray = {""}

	if type == "produce" then
		tempArray = produceIng
	end
	if type == "meat" then
		tempArray = meatIng
	end
	if type == "herb" then
		tempArray = herbIng
	end
	-- Run for produce+grains
	--if type == "produce" then
		for key, value in pairs(tempArray) do
			--TESTINGprint("!!" .. type .. "!!")
			-- Check if this ingredient has already been loaded
			for i, j in pairs(tempList) do
				--TESTINGprint(j .. "::" .. value)
				if j == value then
					--TESTINGprint("BREAK")
					loaded = true
					break
				end
			end

			if loaded == false then
				tempList[tempIndex] = value
				tempIndex = tempIndex + 1
				print(value .. " " .. type)
				ingredient.new(value, type, ingredientXPos, ingredientYPos)
				rowCount = rowCount + 1
				print(ingredient.name)
				-- once we've filled a row, we want to reset our X pos and Y pos
				
				**TO DO**
				**NEED TO ADD A CONDITION FOR IF WE'VE FILLED AN ENTIRE 
				**PANTRY PAGE TO CREATE A NEW PAGE AND START FILLING IT WITH 
				**INGREDIENTS
				
				if rowCount > 3 then
					rowCount = 0
					ingredientXPos = 32
					ingredientYPos = ingredientYPos - Ybuffer
				else
					ingredientXPos = ingredientXPos + Xbuffer
				end
			end
			loaded = false
		end
	--end
end--]]

--[[
A level consists of:
-Level name, as define in level_x.txt 
-recipes, as defined in level_x.txt
-ingredients, pulled from recipe.ingredients[] object--]]
function New(levelName, recipeArray)
	name = levelName
	background = levelName .. "_BG"
	--Initialize recipes in level
	--local produceIndex = 0
	--local herbIndex = 0
	--local meatIndex = 0
	for key, value in pairs(recipeArray) do
		recipe.init(value)
		recipes[key] = recipe		   -- an array of all recipe objects in level
		--TESTprint("key=" .. key)

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
			recipeArray[recipeIndex] = tempArray[2]
			recipeIndex = recipeIndex + 1
		
		elseif tempArray[1] == "background" then
			background = tempArray[2]
		end

		index = 1 -- reset our index to 0 to evaluate the next line
	end
	New(lvlName,recipeArray)
end