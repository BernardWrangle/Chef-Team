--[[A pantry holds ingredients and their behaviors]]--

module(..., package.seeall)

require("class")
require("level")
require("ingredient")

-- Globals
pantryType = "produce"
producePantry = inheritsFrom(baseClass)
produceScene = nil
pantryIngredients = {}
ingArray = {}
isDraggging = false
draggedIngredient = nil
prevDraggedIngredient = nil

-- UI
local returnButton

function returnToKitchen(event)
	tween:to(returnButton, {alpha=1, time=0.5})
	switchToScene("game","shrinkGrow")
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
	end

	if (event.phase == "began") then
		isDragging = true
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
		draggedIngredient = nil
		--[[TODO************************************
		*   Add code that tweens ingredient back   *
		*	to its original position or swap with  *
		*	another ingredient					   *
		************************************TODO]]--
	end
end

function init(ingredients)
	pantryIngredients = ingredients
	produceScene = director:createScene()
	
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
											       source="textures/ingredients/produce/" .. value .. ".png"
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
									   source="textures/objects/bowl.png"
									 })
	prepBowl2 = director:createSprite({x=158, y=120, xAnchor=0.5, yAnchor=0.5,
									   source="textures/objects/bowl.png"
									 })
	prepBowl3 = director:createSprite({x=266, y=120, xAnchor=0.5, yAnchor=0.5,
									   source="textures/objects/bowl.png"
									 })
	prepBowl4 = director:createSprite({x=50, y=40, xAnchor=0.5, yAnchor=0.5,
									   source="textures/objects/bowl.png"
									 })
	prepBowl5 = director:createSprite({x=158, y=40, xAnchor=0.5, yAnchor=0.5,
									   source="textures/objects/bowl.png"
									 })
	prepBowl6 = director:createSprite({x=266, y=40, xAnchor=0.5, yAnchor=0.5,
									   source="textures/objects/bowl.png"
									 })
end