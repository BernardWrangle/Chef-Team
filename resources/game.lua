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
	if (event.phase == "ended") then
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
	if (event.phase == "ended") then
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
	if (event.phase == "ended") then
		--tween:to(MeatButton, {alpha=0, delay=0.08, time=0.25, easing=ease.expIn})
		--tween:to(ProduceButton, {alpha=0, delay=0.08, time=0.25, easing=ease.expIn})
		tween:to(herbButton, {alpha=0, time=0.5, easing=ease.expIn, onComplete=HerbPantry})
	end
end

function HerbPantry(event)
	tween:to(herbButton, {alpha=1, time=0.5})
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
		text="",
		font=defaultFont,
		textXScale = fontScale,
		textYScale = fontScale,
		color = color.black
		})

	produceButton = director:createSprite({x=58, y=248, xAnchor=0.5, yAnchor=0.5,
										   xScale=0.5, yScale=0.5,
										   source="textures/icons/PantryBtn_Pro.png"
										 })
	produceButton:addEventListener("touch", ProduceButtonTouched)

	meatButton = director:createSprite({x=160, y=248, xAnchor=0.5, yAnchor=0.5,
									    xScale=0.5,yScale=0.5,
									    source="textures/icons/PantryBtn_Meat.png"
									  })
	meatButton:addEventListener("touch", MeatButtonTouched)
	
	herbButton = director:createSprite({x=262, y=248, xAnchor=0.5, yAnchor=0.5,
									    xScale=0.5,yScale=0.5,
									    source="textures/icons/PantryBtn_Herbs.png"
									  })
	herbButton:addEventListener("touch", HerbButtonTouched)--]]

	-- Recipe name at top of screen (should be done in level.Load())
	

	--Create ingredients
	
	--[[orange = director:createSprite(Pos1,310,"textures/ingredients/produce/orange.png")
	greenBeans = director:createSprite(Pos2,310,"textures/ingredients/produce/greenbean.png")
	cranberries = director:createSprite(Pos3,310,"textures/ingredients/produce/cranberries.png")
	breadcrumb = director:createSprite(Pos4,310,"textures/ingredients/produce/breadcrumbs.png")
	-- Herbs
	rosemary = director:createSprite(Pos1,240,"textures/ingredients/herb/rosemary.png")
	salt = director:createSprite(Pos2,240,"textures/ingredients/herb/salt.png")
	pepper = director:createSprite(Pos3,240,"textures/ingredients/herb/pepper.png")
	thyme = director:createSprite(Pos4,240,"textures/ingredients/herb/thyme.png")
	--]]
	--[[*****!!!!!
	We'll need to create a different way to 
	determine which pieces of text to display by examining an external file
	!!!!!*****--]]
	-- Create TextObjects for possible ingredients
	--txtGreenbeans = director:createSprite(70,400,"textures/txtGreenbeans.png")
	--txtSalt = director:createSprite(200,420,"textures/txtSalt.png")
	--txtOrange = director:createSprite(8,380,"textures/txtOrange.png")
	
	--[[!!!!!*****
	txtOrange:addEventListener("touch", txtTouch)
	txtGreenbeans:addEventListener("touch", txtTouch)
	txtSalt:addEventListener("touch", txtTouch)*****!!!!!--]]
end

-- Intialize the Game
function init()
	-- create a scene via the director to contain the main game view
	gameScene = director:createScene()

	initUI()
	
	-- Initialize audio
	-- initAudio() !!!!*****A yet-to-be-created funtion*****!!!!!

	--[[Advertising stuff (show or hide) SEE: EXAMPLE Stage9
	if (adverts.enabled == true) then
	    adverts:show()
	    uiYPosition = director.displayHeight - 70
	end--]]

	--initialze level information such as Level name, recipes and ingredients
	level.init(levelIndex)
	
	producePantry.init()
	meatPantry.init()
	herbPantry.init()
	-- Create Ingredient grid
	--ingredientGrid

	-- initialize interface

	-- create pause menu
	--doesn't exist yet but.. pauseMenu.init()
	
	-- create main menu
	mainMenu.init()
	--Add event touch and update handlers
	--!!!!!*****WE'LL NEED THESE AT SOME POINT*****!!!!!
	--system:addEventListener("touch", touch)
	--system:addEventListener("update", update)
end