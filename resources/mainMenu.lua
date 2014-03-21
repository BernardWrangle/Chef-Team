--[[
Main Menu
--]]

module(..., package.seeall)

-- Create a scene to contain the main menu
menuScene = nil

-- Event handlers, tells what happens when a user taps a button
function startGame(event)
	-- Switch to Single player game scene
	switchToScene("game")
	--game:newGame()
end

function newGame2(event)
	  --Switch to Multiplayer game scene
	  switchToScene("game")
end
  
function Recipes(event)
	  --Switch to Recipe scene
	  switchToScene("recipes")
end

function Options(event)
	  --Switch to Options scene
	  switchToScene("options")
end

-- Create and intialize main menu
function init()
	--create the scene to contain the main menu
	menuScene = director:createScene()

	-- Create menu background
	local background = director:createSprite(director.displayCenterX, director.displayCenterY, "textures/menu_bg.jpg")
	background.xAnchor = 0.5
	background.yAnchor = 0.5
	-- Fit background to screen size
	background.xScale = director.displayWidth / 768
	background.yScale = director.displayHeight / 1136

	-- Create Start Game button
	playButton = director:createSprite(director.displayCenterX, 288, "textures/start.png")
	playButton.xAnchor = 0.5
	playButton.yAnchor = 0.5
	playButton.xScale = 0.5
	playButton.yScale = 0.5
	playButton:addEventListener("touch", startGame)

	-- Create Multiplayer Game button
	playButton = director:createSprite(director.displayCenterX, 240, "textures/Multiplayer.png")
	playButton.xAnchor = 0.5
	playButton.yAnchor = 0.5
	playButton.xScale = 0.5
	playButton.yScale = 0.5
	playButton:addEventListener("touch", newGame2)

	-- Create Recipes Game Button
	playButton = director:createSprite(director.displayCenterX, 192, "textures/Recipes.png")
	playButton.xAnchor = 0.5
	playButton.yAnchor = 0.5
	playButton.xScale = 0.5
	playButton.yScale = 0.5
	playButton:addEventListener("touch", Recipes)

	-- Create Options Game Button
	playButton = director:createSprite(director.displayCenterX, 144, "textures/Option.png")
	playButton.xAnchor = 0.5
	playButton.yAnchor = 0.5
	playButton.xScale = 0.5
	playButton.yScale = 0.5
	playButton:addEventListener("touch", Options)

end