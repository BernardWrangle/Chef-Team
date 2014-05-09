--[[A pantry holds ingredients and their behaviors]]--

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
isDragging = false
draggedIngredient = nil
prevDraggedIngredient = nil
ingOrigX = 0
ingOrigY = 0
activeRecipe = level.activeRecipe

-- UI
local returnButton

function returnToKitchen(event)
	tween:to(returnButton, {alpha=1, time=0.2})
	switchToScene("game","slideInL")
	game:returnFromPantry()
end

function returnButtonTouched(event)
	if (event.phase == "began") then
		tween:to(returnButton, {alpha=0.3, time=0.2, onComplete=returnToKitchen})
	end
end

function ingredientTouched(event)
	-- First, check that another ingredient is not being dragged
	if (isDragging == false) then
		draggedIngredient = event.target	
		--TESTprint(event.target)
	end

	if (event.phase == "began") then
		isDragging = true
		ingOrigX = draggedIngredient.x
		ingOrigY = draggedIngredient.y
		--TESTprint("Touch Start")
	end
	
	if (event.phase == "moved") then
		--TESTprint("Dragging")
		if (draggedIngredient ~= nil) then
			tween:to(draggedIngredient, {x=event.x, y=event.y, time=0})
		end
	end

	if (event.phase == "ended") then
		--TESTprint("Touch Ended")
		isDragging = false
		prevDraggedIngredient = draggedIngredient
		tween:to(draggedIngredient, {x=ingOrigX, y=ingOrigY, time=0.2})
		draggedIngredient = nil
		--[[TODO************************************
		*   Add code that tweens ingredient back   *
		*	to its original position or swap with  *
		*	another ingredient					   *
		************************************TODO--]]
	end
end

function init(ingredients)
	pantryIngredients = ingredients
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

	-- Load this levels pantry ingredients
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
			--TESTprint(j .. "::" .. value)
			if j == value then
				--TESTprint("BREAK")
				loaded = true
				break
			end
		end

		if loaded == false then
			tempArray[tempIndex] = value
			tempIndex = tempIndex + 1
			--TESTprint("loading" .. value)
			ingArray[key] = director:createSprite({x=xPos, y=yPos,
											       xAnchor=0.5, yAnchor=0.5, 
											       zOrder=1, source="textures/ingredients/herb/" .. value .. ".png"
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
	prepBowl1 = director:createSprite({x=50, y=120, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl2 = director:createSprite({x=158, y=120, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl3 = director:createSprite({x=266, y=120, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl4 = director:createSprite({x=50, y=40, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl5 = director:createSprite({x=158, y=40, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl6 = director:createSprite({x=266, y=40, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	bowl1Text = director:createLabel({
		x = 30 * game.fontScale, 
		y = 150 * game.fontScale,
		w = director.displayWidth, 
		h = game.actualFontHeight,
		hAlignment = "middle", 
		vAlignment = "middle",
		font = game.defaultFont,
		text = level.activeRecipe.quantities[1], --*TODO* replace recipes[1] with recipes[activeRecipe]
		textXScale = 0.75,
		textYScale = 0.75,
		color = color.black
		})
	bowl1Text = director:createLabel({
		x = 138 * game.fontScale, 
		y = 150 * game.fontScale,
		w = director.displayWidth, 
		h = game.actualFontHeight,
		hAlignment = "middle", 
		vAlignment = "middle",
		font = game.defaultFont,
		text = level.activeRecipe.quantities[2], --*TODO* replace recipes[1] with recipes[activeRecipe]
		textXScale = 0.75,
		textYScale = 0.75,
		color = color.black
		})
	bowl1Text = director:createLabel({
		x = 246 * game.fontScale, 
		y = 150 * game.fontScale,
		w = director.displayWidth, 
		h = game.actualFontHeight,
		hAlignment = "middle", 
		vAlignment = "middle",
		font = game.defaultFont,
		text = level.activeRecipe.quantities[3], --*TODO* replace recipes[1] with recipes[activeRecipe]
		textXScale = 0.75,
		textYScale = 0.75,
		color = color.black
		})
	bowl1Text = director:createLabel({
		x = 30 * game.fontScale, 
		y = 70 * game.fontScale,
		w = director.displayWidth, 
		h = game.actualFontHeight,
		hAlignment = "middle", 
		vAlignment = "middle",
		font = game.defaultFont,
		text = level.activeRecipe.quantities[4], --*TODO* replace recipes[1] with recipes[activeRecipe]
		textXScale = 0.75,
		textYScale = 0.75,
		color = color.black
		})
	bowl1Text = director:createLabel({
		x = 138 * game.fontScale, 
		y = 70 * game.fontScale,
		w = director.displayWidth, 
		h = game.actualFontHeight,
		hAlignment = "middle", 
		vAlignment = "middle",
		font = game.defaultFont,
		text = level.activeRecipe.quantities[5], --*TODO* replace recipes[1] with recipes[activeRecipe]
		textXScale = 0.75,
		textYScale = 0.75,
		color = color.black
		})
	bowl1Text = director:createLabel({
		x = 246 * game.fontScale, 
		y = 70 * game.fontScale,
		w = director.displayWidth, 
		h = game.actualFontHeight,
		hAlignment = "middle", 
		vAlignment = "middle",
		font = game.defaultFont,
		text = level.activeRecipe.quantities[6], --*TODO* replace recipes[1] with recipes[activeRecipe]
		textXScale = 0.75,
		textYScale = 0.75,
		color = color.black
		})
end