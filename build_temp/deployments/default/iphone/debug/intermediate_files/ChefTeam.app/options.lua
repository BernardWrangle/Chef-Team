--Options

optionsScene = director:createScene()

local playButton

function main_menu(event)
  --Switch to the Main Menu Screen
  switchToScene("game") --will be "options" once graphics created
end

-- Create menu background
local background = director:createSprite(director.displayCenterX, director.displayCenterY, "textures/menu_bg.jpg")
background.xAnchor = 0.5
background.yAnchor = 0.5
-- Fit background to screen size
background.xScale = director.displayWidth / 768
background.yScale = director.displayHeight / 1136

-- Create Main Menu button
playButton = director:createSprite(director.displayCenterX, 288, "textures/Menu_button.png")
playButton.xAnchor = 0.5
playButton.yAnchor = 0.5
playButton.xScale = 0.5
playButton.yScale = 0.5
playButton:addEventListener("touch", main_menu)