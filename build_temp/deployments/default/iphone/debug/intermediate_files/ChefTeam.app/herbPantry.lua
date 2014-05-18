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
draggedIngredientName = ""
isOverBowl = false -- True when we are dragging an ingredient over a bowl
activeBowl = nil -- holds the bowl object when isOverBowl is true
activeBowlName = ""
ingOrigX = 0
ingOrigY = 0
ingX = {} -- array of ingredient x coords. key is ingredient name in ingArray key
ingY = {} -- array of ingredient y coords. key is ingredient name in ingArray key
bowlX = {} -- array of bowl x coords. key is bowl name i.e. "bowl1", "bowl2", etc...
bowlY = {} -- array of bowl y coords. key is bowl name i.e. "bowl1", "bowl2", etc...
activeRecipe = level.activeRecipe

-- UI
local returnButton

function returnToKitchen(event)
	tween:to(returnButton, {alpha=1, time=0.1})
	switchToScene("game","slideInL")
	game:returnFromPantry()
end

function returnButtonTouched(event)
	if (event.phase == "began") then
		tween:to(returnButton, {alpha=0.3, time=0.1, onComplete=returnToKitchen})
	end
end

function ingredientTouched(event)
	--TESTprint("**Target name: " .. event.target.name)
	-- First, check that another ingredient is not being dragged

	draggedIngredientName = event.target.name
	
	if (isDragging == false) then
		draggedIngredient = event.target
	end

	if (event.phase == "began") then
		print("Ingredient Touch End")
		isDragging = true
		ingOrigX = ingX[draggedIngredientName]
		ingOrigY = ingY[draggedIngredientName]
		--TESTprint("Touch Start")
	end
	
	if (event.phase == "moved") then
		--TESTprint("Dragging")
		if (draggedIngredient ~= nil) then
			tween:to(draggedIngredient, {x=event.x, y=event.y, time=0})
		end
	end

	if (event.phase == "ended") then
		print("Ingredient Touch End")
		if isOverBowl then
			tmpX = bowlX[activeBowlName]
			tmpY = bowlY[activeBowlName]
			tween:to(draggedIngredient, {x=tmpX, y=tmpY, time=0.2})
			activeBowl = nil
			isOverBowl = false
		else	
			print(draggedIngredientName)
			tween:to(draggedIngredient, {x=ingX[draggedIngredientName], y=ingY[draggedIngredientName], time=0.2})
		end
		prevDraggedIngredient = draggedIngredient
		draggedIngredient = nil
		draggedIngredientName = ""
		isDragging = false
		--[[TODO************************************
		*   Add code that tweens ingredient back   *
		*	to its original position or swap with  *
		*	another ingredient					   *
		************************************TODO]]--
	end
end

function bowlTouched(event)

	activeBowlName = event.target.name
	activeBowl = event.target
	
	if (event.phase == "began") then
		print("Bowl Touch Start")	
	end

	if (event.phase == "moved") then
		if (isDragging == true) then
			print("Bowl Touch Move")
			isOverBowl = true
		end
	end
	
	if (event.phase == "ended") then
		activeBowlName = ""
		activeBowl = nil
		isOverBowl = false
		print("Bowl Touch End")
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
			ingArray[key] = director:createSprite({name=value, x=xPos, y=yPos,
											       xAnchor=0.5, yAnchor=0.5, 
											       zOrder=1, source="textures/ingredients/herb/" .. value .. ".png"
												 })
			ingArray[key]:addEventListener("touch", ingredientTouched)
			ingX[value] = xPos
			ingY[value] = yPos
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

	prepBowl1 = director:createSprite({name = "bowl1", x=50, y=120, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl1:addEventListener("touch", bowlTouched)
	bowlX[prepBowl1.name] = 50
	bowlY[prepBowl1.name] = 120
	
	prepBowl2 = director:createSprite({name = "bowl2", x=158, y=120, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl2:addEventListener("touch", bowlTouched)
	bowlX[prepBowl2.name] = 158
	bowlY[prepBowl2.name] = 120
	
	prepBowl3 = director:createSprite({name = "bowl3", x=266, y=120, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl3:addEventListener("touch", bowlTouched)
	bowlX[prepBowl3.name] = 266
	bowlY[prepBowl3.name] = 120
	
	prepBowl4 = director:createSprite({name = "bowl4", x=50, y=40, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl4:addEventListener("touch", bowlTouched)
	bowlX[prepBowl4.name] = 50
	bowlY[prepBowl4.name] = 40
	
	prepBowl5 = director:createSprite({name = "bowl5", x=158, y=40, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl5:addEventListener("touch", bowlTouched)
	bowlX[prepBowl5.name] = 158
	bowlY[prepBowl5.name] = 40
	
	prepBowl6 = director:createSprite({name = "bowl6", x=266, y=40, xAnchor=0.5, yAnchor=0.5,
									   zOrder=0, source="textures/objects/bowl.png"
									 })
	prepBowl6:addEventListener("touch", bowlTouched)
	bowlX[prepBowl6.name] = 266
	bowlY[prepBowl6.name] = 40

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