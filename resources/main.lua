--[[
Chef Team-
Eric Ochranek &
Zachary McKinley
--]]

--require("mobdebug").start()

-- Limit frame rate to 30 fps (needed for older devices)
system:setFrameRateLimit(30)

-- Create and initialise game
local game = require("game")
game.init()

function exit(event)
	dbg.print("unrequiring")
	unrequire("game")
	unrequire("mainMenu")
	unrequire("options")
	unrequire("recipes")
	unrequire("ingredient")
	unrequire("class")
	unrequire("level")
	unrequire("grid")
	unrequire("textObject")
	--unrequire("xmlSimple")
end
system:addEventListener("exit", exit)

--require("mainMenu")
--require("game")
--require("Options")
--require("Recipes")

-- Switch to specific scene
function switchToScene(scene_name)
	if (scene_name == "game") then
		director:moveToScene(game.gameScene, {transitionType="slideInL", transitionTime=0.5})
	elseif (scene_name == "main") then
		director:moveToScene(mainMenu.menuScene, {transitionType="slideInL", transitionTime=0.5})
	elseif (scene_name == "recipes") then
		director:moveToScene (recipesScene, {transitionType="slideInR", transitionTime=0.5})
	elseif (scene_name == "options") then
		director:moveToScene (optionsScene, {transitionType="slideInR", transitionTime=0.5})
	end
end