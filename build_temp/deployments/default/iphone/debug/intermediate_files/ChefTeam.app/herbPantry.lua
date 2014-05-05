--[[
I think this will just be used to load the pantry scene,
it's a child class of a level object it will reference
everything from level--]]


--[[TO DO: Move ingredient object to pantrys]]
module(..., package.seeall)

require("class")
require("level")
require("ingredient")

-- Globals
pantryType = "herb"
herbPantry = inheritsFrom(baseClass)
herbScene = nil
pantryIngredients = {} -- List of ingredients to load in the level
ingArray = {}	-- array of loaded ingredients in level

-- UI
local returnButton

-- Create the pantry
function new(ingredients)
	local o = herbPantry:create()
	herbPantry:init(o)
	return o
end

function returnToKitchen(event)
	tween:to(returnButton, {alpha=1, time=0.5})
	switchToScene("game","shrinkGrow")
	game:returnFromPantry()
end

function returnButtonTouched(event)
	if (event.phase == "ended") then
		tween:to(returnButton, {alpha=0.3, time=0.2, onComplete=returnToKitchen})
	end
end

function setPantryType(pantry_type)
	pantryType = pantry_type
end

function init(ingredients)
	pantryIngredients = ingredients
	--LoadIngredients()

	herbScene = director:createScene()
	
	local bg = director:createSprite(director.displayCenterX, director.displayCenterY, "textures/backgrounds/1_BG.png")
	bg.xAnchor = 0.5
	bg.yAnchor = 0.5
	-- Fit background to screen size
	local bg_width, bg_height = bg:getAtlas():getTextureSize()
	bg.xScale = director.displayWidth / bg_width
	bg.yScale = director.displayHeight / bg_height

	returnButton = director:createSprite({x=160, y=400, xAnchor=0.5, yAnchor=0.5,
										  source="textures/icons/KitchenKey.png"
										 })
	returnButton:addEventListener("touch", returnButtonTouched)

	print("here")

	local xPos = 32
	local yPos = 300
	local rowCount = 0
	local yBuffer = 76
	local xBuffer = 64
	local tempArray = {} -- a temp array to detect duplicate ingredients
	local loaded = false
	local tempIndex = 0

	for key, value in pairs(pantryIngredients) do
		for i, j in pairs(tempArray) do
			print(j .. "::" .. value)
			if j == value then
				print("BREAK")
				loaded = true
				break
			end
		end

		if loaded == false then
			tempArray[tempIndex] = value
			tempIndex = tempIndex + 1
			print("loading" .. value)
			ingArray[key] = director:createSprite({x=xPos, y=yPos,
											       xAnchor=0.5, yAnchor=0.5, 
											       source="textures/ingredients/herb/" .. value .. ".png"
												 })
			ingArray[key]:addEventListener("touch", ingredientTouched)

			rowCount = rowCount + 1
			if rowCount > 3 then
				rowCount = 0
				xPos = 32
				yPos = yPos - yBuffer
			else
				xPos = xPos + xBuffer
			end
			--[[once we've filled a row, we want to reset our X pos and Y pos
			**TO DO**
			**NEED TO ADD A CONDITION FOR IF WE'VE FILLED AN ENTIRE 
			**PANTRY PAGE TO CREATE A NEW PAGE AND START FILLING IT WITH 
			**INGREDIENTS]]	
		end
	end
	
end

function ingredientTouched(event)
	--[[************************************************
	*TODO: Detect whether another ingredient is already*
	*selected, if so, you can not move this ingredient *
	************************************************]]--
	if (event.phase == "moved") then
		tween:to(event.target, {x=event.x, y=event.y, time=0})
	end
end



--[[
function LoadPantry(type)

	--ingredient.new(value, type, ingredientXPos, ingredientYPos)
	
	print("Loading Pantry...")
	
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
		tempArray = level.produceIng
	end
	if type == "meat" then
		tempArray = level.meatIng
	end
	if type == "herb" then
		tempArray = level.herbIng
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
				print("WTF")
				[once we've filled a row, we want to reset our X pos and Y pos
				**TO DO**
				**NEED TO ADD A CONDITION FOR IF WE'VE FILLED AN ENTIRE 
				**PANTRY PAGE TO CREATE A NEW PAGE AND START FILLING IT WITH 
				**INGREDIENTS]
				--
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
end]]