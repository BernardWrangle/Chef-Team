--[[
Defines ingredient object
--]]

module(..., package.seeall)

-- OO functions
require("class")
require("level") --we will be pulling information such as type,x,y from level eventually

-- Create the ingredient class
ingredient = inheritsFrom(baseClass)

local ingredientAtlases = {}
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/herb/basil.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/herb/pepper.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/herb/rosemary.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/herb/salt.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/herb/thyme.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/meat/anchovies.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/meat/beef_stock.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/meat/butter.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/meat/cured_pork_belly.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/meat/egg.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/meat/mozzarella.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/meat/ramen_broth.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/breadcrumbs.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/cranberries.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/crushed_tomatoes.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/dough.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/garlic.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/greenbean.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/lemon.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/nori.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/olive_oil.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/orange.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/ramen_noodles.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/romaine_lettuce.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/scallion.png" }))
table.insert(ingredientAtlases, director:createAtlas( { width=64, height=64, numFrames=1, textureName="textures/ingredients/produce/slivered_almonds.png" }))

-- Globals
name				=	""		-- name of ingredient
type				=	""		-- type of ingredient (either P(produce+grain), M(meat+dairy), H(herb+spice)
isSelected			= false		-- this will be true if this object draggable=true and is touched
quantity			=	""		-- quantity of ingredient, i.e. "1CUP", "1TBLS", etc...
ingredientBitmapWidth, ingredientBitmapHeight = ingredientAtlases[1]:getTextureSize()
ingredientBitmapWidth = ingredientBitmapWidth / 5
ingredientBitmapHeight = ingredientBitmapHeight / 3
ingredientActualWidth	= (director.displayWidth * ingredientBitmapWidth) / game.graphicDesignWidth
ingredientActualHeight = ingredientActualWidth
ingredientHeight	= 64
ingredientRetractSpeed	= 500	--This is the speed at which the ingredient moves back to it's position in the row if not placed in staging area
draggable			= false		--This is true if the corresponding TextObject.isSelected=true
--ID					= nil		--Use this to match with txtObject IDs **REMOVED FROM PROJECT**

function IngTouch(event)
	print("touched")
	tween:to(ing, {rotation=360, time=0.5})
end

-- Create the ingredient and place it
function new(name,type,x,y)
	local o = ingredient:create()
	print("Loading Ingredient")
	ingredient:init(o, name, type, x, y)
	return o
end

-- Initialise the ingredient
function ingredient:init(o, name, type, x, y)
	-- Create sprite
	print("Loding Ingredient: " .. name .. " at: " .. x .. " " .. y)
	o.sprite = director:createSprite(x, y)
	o.sprite.xScale = ingredientActualWidth / ingredientBitmapWidth
	o.sprite.yScale = ingredientActualHeight / ingredientBitmapHeight
	o.type = type
	o.name = name
	--ing:addEventListener("touch", IngTouch)
	--ing.xScale = ingredientImageWidth
	--ing.yScale = ingredientImageHeight
	--ing.type = type
end

function ingredient:setPantry(type, ingredientArray)
	if(type == "herb") then
		self.sprite:setAnimation(director:createAnimation({start=1, count=1, atlas=ingredientAtlases[1], delay=0}))
	end
end
