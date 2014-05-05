--[[
Main game logic
--]]

module(..., package.seeall)

-- Globals & constants
graphicDesignWidth = 768
fontHeight = 15
fontWidth = 320
RoundTime = 400  --round ends after 4 minutes
fontScale = director.displayWidth / fontWidth
actualFontHeight = fontHeight * fontScale
graphicScale = director.displayWidth / graphicDesignWidth
defaultFont = director:createFont("fonts/ComicSans24.fnt")
pantryType = ""
recipes = {}

--OO functions
local class = require("class")
require("grid")
require("mainMenu")
require("pauseMenu")
require("recipe")
require("level")
require("producePantry") 
require("meatPantry") 
require("herbPantry") 
require("ingredient")
--This is used to determine which pantry to go to and which ingredients to load. Shared by Pantry.Lua and Level.Lua

-- Local constants


gameStates = {
	paused				= 0, --Game is paused
	producePantry		= 1, --Game is waiting for player to select a text object
	meatPantry			= 2,
	herbPantry			= 3,
	waitingPantrySelect	= 4,
	waitingIng1Select	= 5, --Text object has been selected, waiting for player to find ingredient
	ingredientSelected	= 6,
	dragging			= 7, --Player is dragging ingredient
	waitingFire			= 8, --All staging area slots are full, waiting for player to select "Fire It!"
	levelOver			= 9 --Level has ended
}


-- The game scenes
gameScene = nil

-- locals
local currentRecipeIndex = 1    --Current recipe in play
local currentRecipeTime = 0     --Amount of time passed since start
local currentRecipeScore = 0	--Current recipe score
local targetRecipeScore = 0		--Score needed to move on, !!!!!SHOULD BE SET BY LEVEL!!!!!
local ingredientGrid			--Grid of ingredients
local gridTouchX = -1			--X Location on grid of touch
local gridTouchY = -1			--Y Location on grid of touch
local levelIndex = 1			--current level, start at 1
local Pos1 = 8
local Pos2 = 88
local Pos3 = 168
local Pos4 = 248

--UI components
--local timerLabelText
--local pauseSprite
local uiYPosition = director.displayHeight


-- Changes the game state
function changeGameState(game_state)
	gameState = game_state
end

--[[!!!!!*****THIS IS CALLED FROM MAIN AND PAUSE*****!!!!!function newGame()
	-- initRound()
	-- Log new game event
	-- stats:logEvent("New Game")
end--]]

--[[*****!!!!!MAIN GAME LOOP. UPDATE EVERYTHING, TIMER SCORES
IN HERE Game update loop
local update = function(event)
	-- Update falling gems in grid
	if (gameState == gameStates.gemsFalling) then
		gemsGrid:gemsFalling()
	end
	-- Update round timer
	if (gameState ~= gameStates.roundOver and gameState ~= gameStates.paused) then
		timerLabel.text = math.floor(currentRoundTime)
		currentRoundTime = currentRoundTime - system.deltaTime
		if (currentRoundTime <= 0) then
			currentRoundTime = 0
			-- Allow last played move to finish
			if (gameState == gameStates.waitingFirstGem or gameState == gameStates.waitingSecondGem) then
				endOfRound()
			end
		end
	end
	-- Update explosions
	explosion.updateExplosions()
end --]]

function ProduceButtonTouched(event)
	pantryType = "produce"
	if (event.phase == "began") then
		--tween:to(MeatButton, {alpha=0, delay=0.08, time=0.25, easing=ease.expIn})
		--tween:to(HerbButton, {alpha=0, delay=0.08, time=0.25, easing=ease.expIn})
		tween:to(produceButton, {alpha=0, time=0.5, easing=ease.expIn, onComplete=ProducePantry})
	end
end

function ProducePantry(event)
	-- reset menu
	--oldGameState = gameState
	--gameState = gameStates.producePantry
	tween:to(produceButton, {alpha=1, time=0.5})
	switchToScene("produceScene")
end

function MeatButtonTouched(event)
	pantryType = "meat"
	if (event.phase == "began") then
		--tween:to(ProduceButton, {alpha=0, delay=0.08, time=0.25, easing=ease.expIn})
		--tween:to(HerbButton, {alpha=0, delay=0.08, time=0.25, easing=ease.expIn})
		tween:to(meatButton, {alpha=0, time=0.5, easing=ease.expIn, onComplete=MeatPantry})
	end
end

function MeatPantry(event)
	tween:to(meatButton, {alpha=1, time=0.5})
	switchToScene("meatScene")
end

function HerbButtonTouched(event)
	pantryType = "herb"
	if (event.phase == "began") then
		--tween:to(MeatButton, {alpha=0, delay=0.08, time=0.25, easing=ease.expIn})
		--tween:to(ProduceButton, {alpha=0, delay=0.08, time=0.25, easing=ease.expIn})
		tween:to(herbButton, {alpha=0, time=0.5, easing=ease.expIn, onComplete=HerbPantry})
	end
end

function HerbPantry(event)
	tween:to(herbButton, {alpha=1, time=0.5})
	--level.ingredient:setPantry("herb", level.herbIng) --tell our ingredients which ones to draw in the pantry
	switchToScene("herbScene")
end

function returnFromPantry()
	oldGameState = gameState
	gameState = gameStates.waitingPantrySelect
end

function initUI()
	-- load background, which is specific to level.
	local bg = director:createSprite(director.displayCenterX, director.displayCenterY, "textures/backgrounds/" .. levelIndex .. "_BG.png")
	bg.xAnchor = 0.5
	bg.yAnchor = 0.5
	-- Fit background to screen size
	local bg_width, bg_height = bg:getAtlas():getTextureSize()
	bg.xScale = director.displayWidth / bg_width
	bg.yScale = director.displayHeight / bg_height
	
	levelName = director:createLabel({
		x = 20 * fontScale, 
		y = uiYPosition - 20 * fontScale,
		w = director.displayWidth,
		h = actualFontHeight,
		text=level.name, 
		hAlignment="left", 
		vAlignment="top",
		font=defaultFont,
		textXScale = fontScale,
		textYScale = fontScale,
		color = color.black
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
		text = level.activeRecipe.name,
		textXScale = fontScale,
		textYScale = fontScale,
		color = color.black
		})

	timerLabel = director:createLabel({
		x = -10 * fontScale, 
		y = uiYPosition - 22 * fontScale,
		w = director.displayWidth, 
		h = actualFontHeight,
		hAlignment="right", 
		vAlignment="top",
		text="",
		font=defaultFont,
		textXScale = fontScale,
		textYScale = fontScale,
		color = color.black
		})

	produceButton = director:createSprite({
		x=58, y=248, 
		xAnchor=0.5, yAnchor=0.5,
		xScale=0.5, yScale=0.5,
		source="textures/icons/PantryBtn_Pro.png"
		})
	produceButton:addEventListener("touch", ProduceButtonTouched)

	meatButton = director:createSprite({
		x=160, y=248, 
		xAnchor=0.5, yAnchor=0.5,
		xScale=0.5,yScale=0.5,
		source="textures/icons/PantryBtn_Meat.png"
		})
	meatButton:addEventListener("touch", MeatButtonTouched)
	
	herbButton = director:createSprite({
		x=262, y=248, 
		xAnchor=0.5, yAnchor=0.5,
		xScale=0.5,yScale=0.5,
		source="textures/icons/PantryBtn_Herbs.png"
		})
	herbButton:addEventListener("touch", HerbButtonTouched)
	
	-- Load prep area bowls
	prepBowl1 = director:createSprite({
		x=50, y=120, xAnchor=0.5, yAnchor=0.5,
		zOrder=0, source="textures/objects/bowl.png"
		})
	prepBowl2 = director:createSprite({
		x=158, y=120, xAnchor=0.5, yAnchor=0.5,
		zOrder=0, source="textures/objects/bowl.png"
		})
	prepBowl3 = director:createSprite({
		x=266, y=120, xAnchor=0.5, yAnchor=0.5,
		zOrder=0, source="textures/objects/bowl.png"
		})
	prepBowl4 = director:createSprite({
		x=50, y=40, xAnchor=0.5, yAnchor=0.5,
		zOrder=0, source="textures/objects/bowl.png"
		})
	prepBowl5 = director:createSprite({
		x=158, y=40, xAnchor=0.5, yAnchor=0.5,
		zOrder=0, source="textures/objects/bowl.png"
	    })
	prepBowl6 = director:createSprite({
		x=266, y=40, xAnchor=0.5, yAnchor=0.5,
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
	-- Recipe name at top of screen (should be done in level.Load())
end

local touch = function(event)
	if (director:getCurrentScene() == produceScene and event.phase == "began") then
		-- Get touched pos
		print(event.x .. " " .. event.y .. " " .. event.phase)
	end
	--TESTINGprint(event.x .. " " .. event.y .. " " .. event.phase)
end

local update = function(event)

end

-- Intialize the Game
function init()
	-- create a scene via the director to contain the main game view
	gameScene = director:createScene()
	--[[*TODO*Initialize audio
	-- initAudio()*TODO*--]]

	--[[*TODO*Advertising stuff (show or hide) SEE: EXAMPLE Stage9
	if (adverts.enabled == true) then
	    adverts:show()
	    uiYPosition = director.displayHeight - 70
	end*TODO*--]]

	--initialze level information such as Level name, recipes and ingredients
	level.init(levelIndex)
	initUI()
	print(level.recipes[1].name)
	producePantry.init(level.produceIng) --We should send the pantry a list of ingredients in the pantry, so
	meatPantry.init(level.meatIng)
	herbPantry.init(level.herbIng)
	
	
	-- Create Ingredient grid
	--ingredientGrid

	-- initialize interface

	-- create pause menu
	--doesn't exist yet but.. pauseMenu.init()
	
	-- create main menu
	mainMenu.init()
	--Add event touch and update handlers
	--!!!!!*****WE'LL NEED THESE AT SOME POINT*****!!!!!
	system:addEventListener("touch", touch)
	system:addEventListener("update", update)
end