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
	unrequire("recipe")
	unrequire("producePantry")
	unrequire("meatPantry")
	unrequire("herbPantry")
end
system:addEventListener("exit", exit)

-- Switch to specific scene
function switchToScene(scene_name, transition_type)
	if (scene_name == "game") then
		if (transition_type == "shrinkGrow") then
			director:moveToScene(game.gameScene, {transitionType="shrinkGrow", transitionTime=1.5})
		else
			director:moveToScene(game.gameScene, {transitionType="slideInL", transitionTime=0.5})
		end
	elseif (scene_name == "main") then
		director:moveToScene(mainMenu.menuScene, {transitionType="slideInL", transitionTime=0.5})
	elseif (scene_name == "recipes") then
		director:moveToScene (recipesScene, {transitionType="slideInR", transitionTime=0.5})
	elseif (scene_name == "options") then
		director:moveToScene (optionsScene, {transitionType="slideInR", transitionTime=0.5})
	elseif (scene_name == "produceScene") then
		director:moveToScene (producePantry.produceScene, {transitionType="shrinkGrow", transitionTime=1.5})
	elseif (scene_name == "meatScene") then
		director:moveToScene (meatPantry.meatScene, {transitionType="shrinkGrow", transitionTime=1.5})
	elseif (scene_name == "herbScene") then
		director:moveToScene (herbPantry.herbScene, {transitionType="shrinkGrow", transitionTime=1.5})
	end
end