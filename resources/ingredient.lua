--[[
Defines ingredient object
--]]

module(..., package.seeall)

-- OO functions
require("class")
require("game")
require("level") --we will be pulling information such as type,x,y from level eventually

-- Globals
isSelected			= false		-- this will be true if this object draggable=true and is touched
ingredientWidth		= 64
ingredientHeight	= 64
ingredientRetractSpeed	= 500	--This is the speed at which the ingredient moves back to it's position in the row if not placed in staging area
originalPosX		= 0			--Keep track of original X pos, !!!NOT DEFINED ANYWHERE YET!!!
originalPosY		= 0			--Keep track of original Y pos, !!!NOT DEFINED ANYWHERE YET!!!
draggable			= false		--This is true if the corresponding TextObject.isSelected=true
ID					= nil		--Use this to match with txtObject IDs

-- Create the ingredient class
ingredient = inheritsFrom(baseClass)

-- Create the ingredient and place it
function new(type, x, y)
	local o = ingredient:create()
	gem:init(o,type,x,y)
	return o
end

-- Initialise the ingredient
function ingredient:init(o, type, x, y)
	-- Create sprite
	o.sprite = director:createSprite(x,y,"textures/ingredients" .. type .. ".png")
	o.sprite.xScale = ingredientImageWidth
	o.sprite.yScale = ingredientImageHeight
	o.type = type
end
