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
name				= ""	-- name of level
recipes				= {}	-- pool of recipes
produceIng			= {}	-- ingredients to include in produce+grains pantry (pulled from recipes)
herbIng				= {}	-- ingredients to include in herb+spice pantry
meatIng				= {}	-- ingredients to include in meat+dairy pantry
activeRecipe		= ""	-- name of the active recipe. Active recipe is one that has it's quantities in the bottom section
background			= nil	-- background image for level
ingredientCountY	= 3		-- total rows in pantry, will always be 3

-- Local
local ingredientsGrid		-- Grid of ingredients
local prepContainerGrid		-- Grid of preperation containers
local ingredientCountX		= 0	-- Total columns in pantry grid (test value of 4 right now, later will be expanded)

-- Constants
gridActualHeight	= 64 * ingredientCountY--[[replace with ingredient.IngredientHeight * ingredientCountY--]]
gridOffsetX			= 41 * game.graphicScale -- Grid offset screen position on x-axis
gridOffsetY			= 37 * game.graphicScale -- Grid offset screen position on y-axis	
produceYPos			= 300
herbYPos			= 230
meatYPos			= 160

-- Level
level = inheritsFrom(baseClass)

--[[
Load the levels recipe tags, ingredient sprites, labels,
pantry rows, prep area Fire It! and FX
--]]
function Load(fontScale, uiYPosition, actualFontHeight, defaultFont)
	-- Load background for level first
	local bg = director:createSprite(director.displayCenterX, director.displayCenterY, "textures/backgrounds/" .. background .. ".png")
	bg.xAnchor = 0.5
	bg.yAnchor = 0.5
	-- Fit background to screen size
	local bg_width, bg_height = bg:getAtlas():getTextureSize()
	bg.xScale = director.displayWidth / bg_width
	bg.yScale = director.displayHeight / bg_height

	-- Level name
	levelName = director:createLabel({
		x = 20 * fontScale, 
		y = uiYPosition - 20 * fontScale,
		w = director.displayWidth,
		h = actualFontHeight,
		text=name, 
		hAlignment="left", 
		vAlignment="top",
		font=defaultFont,
		textXScale = fontScale,
		textYScale = fontScale,
		color = color.red
	})

	-- Level Timer
	timerLabelText = director:createLabel({
		x = director.displayWidth - 100 * fontScale, 
		y = uiYPosition - 20 * fontScale,
		w = director.displayWidth, 
		h = actualFontHeight,
		hAlignment = "left", 
		vAlignment = "top",
		font = defaultFont,
		text = "Time",
		textXScale = fontScale,
		textYScale = fontScale,
		color = color.red
		})

	timerLabel = director:createLabel({
		x = -10 * fontScale, 
		y = uiYPosition - 22 * fontScale,
		w = director.displayWidth, 
		h = actualFontHeight,
		hAlignment="right", 
		vAlignment="top",
		text="12:20",
		font=defaultFont,
		textXScale = fontScale,
		textYScale = fontScale,
		color = color.black
		})

	-- Load Kitchen icons
	ProduceButton = director:createSprite(8, 228, "textures/icons/PantryBtn_Pro.png")
	ProduceButton.xAnchor = 0
	ProduceButton.yAnchor = 0
	ProduceButton.xScale = 0.5
	ProduceButton.yScale = 0.5
	ProduceButton.addEventListener("touch", ProducePantry)

	MeatButton = director:createSprite(110, 228, "textures/icons/PantryBtn_Meat.png")
	MeatButton.xAnchor = 0
	MeatButton.yAnchor = 0
	MeatButton.xScale = 0.5
	MeatButton.yScale = 0.5
	MeatButton:addEventListener("touch", MeatPantry)
	
	HerbButton = director:createSprite(212, 228, "textures/icons/PantryBtn_Herbs.png")
	HerbButton.xAnchor = 0
	HerbButton.yAnchor = 0
	HerbButton.xScale = 0.5
	HerbButton.yScale = 0.5
	HerbButton:addEventListener("touch", HerbPantry)
	-- Load Ingredients
	--LoadPantry()

	-- Load prep area grid

	-- Load produce pantry
	
	-- Load Tickets

end

function ProudcePantry()
	timerLabel.text = "000"
end

function MeatPantry()

end

function HerbPantry()

end

function LoadPantry()
	local ingredientXPos = 32 -- starting position of ingredients in pantry row
	local ingredientYPos = 300
	local Xbuffer = 64
	local Ybuffer = 76
	local tempList = {""}		-- Use this to keep track of loaded assets, if already in this list, then it's already been loaded
	local tempIndex = 1
	local rowCount = 0
	local loaded = false

	-- Run for produce+grains
	for key, value in pairs(produceIng) do
		local ingType = "produce"
		print("!!" .. ingType .. "!!")
		-- Check if this ingredient has already been loaded
		for i, j in pairs(tempList) do
			print(j .. "::" .. value)
			if j == value then
				print("BREAK")
				loaded = true
				break
			end
		end

		if loaded == false then
			tempList[tempIndex] = value
			tempIndex = tempIndex + 1
			print(value .. " " .. ingType)
			ingredient.new(value, ingType, ingredientXPos, ingredientYPos)
			rowCount = rowCount + 1
			
			-- once we've filled a row, we want to reset our X pos and Y pos
			--[[
			**TO DO**
			**NEED TO ADD A CONDITION FOR IF WE'VE FILLED AN ENTIRE 
			**PANTRY PAGE TO CREATE A NEW PAGE AND START FILLING IT WITH 
			**INGREDIENTS
			--]]
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

	-- Run for herbs+spices
	--[[for key, value in pairs(produceIng) do
		local type = "produce"
		-- Load image
		for i, j in pairs(tempList) do
			print(j .. "::" .. value)
			if j == value then
				print("BREAK FOR DUPE")
				loaded = true
				break
			end
		end
		if loaded == false then
			tempList[tempIndex] = value
			tempIndex = tempIndex + 1
			LoadIngredientSprite(value, type, ingredientXPos)
			ingredientXPos = ingredientXPos + buffer
		end
		loaded = false
	end

	-- Run for meat+dairy
	for key, value in pairs(produceIng) do
		local type = "produce"
		-- Load image
		for i, j in pairs(tempList) do
			print(j .. "::" .. value)
			if j == value then
				print("BREAK FOR DUPE")
				loaded = true
				break
			end
		end
		if loaded == false then
			tempList[tempIndex] = value
			tempIndex = tempIndex + 1
			LoadIngredientSprite(value, type, ingredientXPos)
			ingredientXPos = ingredientXPos + buffer
		end
		loaded = false
	end--]]
end
--[[
A level consists of:
-Level name, as define in level_x.txt 
-recipes, as defined in level_x.txt
-ingredients, pulled from recipe.ingredients[] object--]]
function New(levelName, recipeArray)
	name = levelName

	--Initialize recipes in level
	local produceIndex = 0
	local herbIndex = 0
	local meatIndex = 0
	for key, value in pairs(recipeArray) do
		recipe.init(value)
		recipes[key] = recipe		   -- an array of all recipe objects in level
		--TESTprint("key=" .. key)

		-- Initialize lists of ingredient types
		for i, j in pairs(recipes[key].ingredients) do
			local type = recipes[key].ingredientType[i]
			print("value=" .. j .. " type=" .. type)   -- tesing to see if objects are correct
			
			if type == "produce" then
				print("Inserting ingredient " .. j .. " into Produce array")
				produceIng[produceIndex] = j   -- add ingredient to list
				ingredientCountX = ingredientCountX + 1 --increase our number of ingredients in the level
				produceIndex = produceIndex + 1
			elseif type == "herb" then
				herbIng[herbIndex] = j
				ingredientCountX = ingredientCountX + 1
				herbIndex = herbIndex + 1
			elseif type == "meat" then
				meatIng[meatIndex] = j
				ingredientCountX = ingredientCountX + 1
				meatIndex = meatIndex + 1
			end
		end
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

function LoadIngredientSprite(ingName, type, xPos)
	print("LOADING INGREDIENT: " .. ingName .. " AT: " .. xPos)
	ing = director:createSprite(xPos,produceYPos,"textures/ingredients/" .. type .. "/" .. ingName .. ".png")
end