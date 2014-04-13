--[[
Defines ingredient object
--]]

module(..., package.seeall)

-- OO functions
require("class")
require("game")
require("level") --we will be pulling information such as type,x,y from level eventually

-- Globals
name				=	""		-- name of ingredient
type				=	""		-- type of ingredient (either P(produce+grain), M(meat+dairy), H(herb+spice)
isSelected			= false		-- this will be true if this object draggable=true and is touched
quantity			=	""		-- quantity of ingredient, i.e. "1CUP", "1TBLS", etc...
ingredientWidth		= 64
ingredientHeight	= 64
ingredientRetractSpeed	= 500	--This is the speed at which the ingredient moves back to it's position in the row if not placed in staging area
PosX				= 0			--Keep track of original X pos, !!!NOT DEFINED ANYWHERE YET!!!
PosY				= 0			--Keep track of original Y pos, !!!NOT DEFINED ANYWHERE YET!!!
draggable			= false		--This is true if the corresponding TextObject.isSelected=true
--ID					= nil		--Use this to match with txtObject IDs **REMOVED FROM PROJECT**

-- Create the ingredient class
ingredient = inheritsFrom(baseClass)

-- Create the ingredient and place it
function new(name,type,x,y)
	print("Loading Ingredient")
	PosX = x
	PosY = y
	type = type
	name = name
	init(name, type)
end

-- Initialise the ingredient
function init(name, type)
	-- Create sprite
	print("LOADING INGREDIENT: " .. name .. " AT: " .. PosX)
	ing = director:createSprite(PosX,PosY,"textures/ingredients/" .. type .. "/" .. name .. ".png")
	--ing.xScale = ingredientImageWidth
	--ing.yScale = ingredientImageHeight
	--ing.type = type
end
