--[[
I think this will just be used to load the pantry scene,
it's a child class of a level object it will reference
everything from level--]]

module(..., package.seeall)

-- Globals
pantry = nil
pantryType = "produce"

-- UI
local returnButton

produceScene = nil

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

function init()
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

	level.LoadPantry(pantryType)
	--produceScene = director:createScene()
	--meatScene = director:createScene() 
	--herbScene = director:createScene()
end