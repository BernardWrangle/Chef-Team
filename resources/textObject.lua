--[[
This is a TextObject that represents an ingredient in
the pantry. TextObjects are created at the same time as Ingredient objects.
When a TextObject is touched, it does two things:
1) de-selects any other TextObject if isSelected=true
2) makes it's matching Ingredient object draggable=true--]]

module(..., package.seeall)

-- OO functions
require("class")
require("game")

-- Txt animations

-- Globals
txtObjWidth = 64
txtObjHeight = 64
txtObjActualWidth = (director.displayWidth * txtObjWidth) / game.graphicDesignWidth -- The actual device coordinate width of the object
txtObjActualHeight = txtObjActualWidth
isSelected = false
ID = nil --ID is what we'll use to match txtObj with the Ingredient ID

-- textObject class
txtObject = inheritsFrom(baseClass)

-- create an instance of a new txtObj
function new(ID, x, y)
	local o = txtObj:create()
	txtObj:init(o, ID, x, y)
	return o
end

-- intialize txtObj
function txtObj:init(o, ID, x, y)
	-- create sprite
	o.sprite = director:createSprite(x, y)
	o.sprite.xScale = txtObjActualWidth / txtObjWidth
	o.sprite.yScale = txtObjActualHeight / txtObjHeight
	o.ID = ID
end