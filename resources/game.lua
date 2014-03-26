--[[
Main game logic
--]]

module(..., package.seeall)

-- Global Constants
ingredientCountX = 4		--Total columns in pantry grid (test value of 4 right now, later will be expanded)
ingredientCountY = 3		--total row in pantry	
graphicDesignWidth = 768
fontHeight = 15
fontWidth = 320

--OO functions
local class = require("class")
require("grid")
require("mainMenu")
require("pauseMenu")
require("recipe")

-- Local constants
RoundTime = 400  --round ends after 4 minutes
fontScale = director.displayWidth / fontWidth
actualFontHeight = fontHeight * fontScale
graphicScale = director.displayWidth / graphicDesignWidth
gridActualHeight = 64 * ingredientCountY--[[replace with ingredient.IngredientHeight * ingredientCountY--]]
gridOffsetX = 41 * graphicScale -- Grid offset screen position on x-axis
gridOffsetY = 37 * graphicScale -- Grid offset screen position on y-axis
defaultFont = director:createFont("fonts/ComicSans24.fnt")


gameStates = {
	paused				= 0, --Game is paused
	waitingTxtSelection = 1, --Game is waiting for player to select a text object
	waitingIngSelection = 2, --Text object has been selected, waiting for player to find ingredient
	dragging			= 3, --Player is dragging ingredient
	ingredientSnap		= 4, --Player has placed ingredient somewhere other than staging area, snapping ingredient back to it's orignal position
	waitingFire			= 5, --All staging area slots are full, waiting for player to select "Fire It!"
	levelOver			= 6 --Level has ended
}

-- The game scene
gameScene = nil

-- Game state
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

function initUI()
	-- Create ingredient sprites
	-- Produce
	--[[*****!!!!!This is a rather hamfisted approach of creating these sprites, 
	in the future we will need some way of telling the game which ingredients 
	to pick and where to place them by reading an external file of some sort (xml?)!!!!!*****--]]

	-- Create game background
	local background = director:createSprite(director.displayCenterX, director.displayCenterY, "textures/game_bg.png")
	background.xAnchor = 0.5
	background.yAnchor = 0.5
	-- Fit background to screen size
	local bg_width, bg_height = background:getAtlas():getTextureSize()
	background.xScale = director.displayWidth / bg_width
	background.yScale = director.displayHeight / bg_height
	
	-- Recipe name at top of screen
	recipeName = director:createLabel({
		x = 20 * fontScale, y = uiYPosition - 20 * fontScale,
		w = director.displayWidth, h = actualFontHeight,
		text=level.name, 
		hAlignment="left", vAlignment="top",
		font=defaultFont,
		textXScale = fontScale,
		textYScale = fontScale,
		color = color.red
	})

	--Create ingredients
	orange = director:createSprite(Pos1,310,"textures/ingredients/orange.png")
	greenBeans = director:createSprite(Pos2,310,"textures/ingredients/greenbean.png")
	cranberries = director:createSprite(Pos3,310,"textures/ingredients/cranberries.png")
	breadcrumb = director:createSprite(Pos4,310,"textures/ingredients/breadcrumbs.png")
	-- Herbs
	rosemary = director:createSprite(Pos1,240,"textures/ingredients/rosemary.png")
	salt = director:createSprite(Pos2,240,"textures/ingredients/salt.png")
	pepper = director:createSprite(Pos3,240,"textures/ingredients/pepper.png")
	thyme = director:createSprite(Pos4,240,"textures/ingredients/thyme.png")

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

	--initialze level
	level.init(levelIndex)
	
	--initialize recipes in level

	-- initialize interface
	initUI()

	-- create pause menu
	--doesn't exist yet but.. pauseMenu.init()

	-- create main menu
	mainMenu.init()

	--Add event touch and update handlers
	--!!!!!*****WE'LL NEED THESE AT SOME POINT*****!!!!!
	--system:addEventListener("touch", touch)
	--system:addEventListener("update", update)
end