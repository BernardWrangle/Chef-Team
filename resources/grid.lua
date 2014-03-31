--[[
A grid game object. Used to place ingredients in rows
--]]

module(..., package.seeall)

require("class")
require("ingredient")

-- Create grid class
grid = inheritsFrom(baseClass)

-- Create an instance of a new grid
function new(ingredients_wide, ingredients_high, ingredients_offset_x, ingredients_offset_y)
	local o = grid:create()
	grid:init(o, ingredients_wide, ingredients_high, ingredients_offset_x, ingredients_offset_y)
	return o
end

-- convert screen x, y to grid
function grid:screenToGrid(x,y)
	local grid_x = math.floor((x - self.offsetX) / ingredient.ingredientWidth + 0.001)
	local grid_y = math.floor((y - self.offsetY) / ingredient.ingredientHeight + 0.001)
	return grid_x + 1, grid_y + 1
end

--Get ingredient at screen x, y
function grid:getIngredient(x,y)
	local grid_x, grid_y = self.screendToGrid(x,y)
	return self.ingredientsGrid[grid_x][grid_y]
end

-- Initialize the grid
function grid:init(o,ingredients_wide,ingredients_high,ingredient_offset_x,ingredient_offset_y)
	o.width = ingredients_wide
	o.height = ingredients_high
	o.offsetX = ingredients_offset_x
	o.offsetY = ingredients_offset_y

	-- Create grid of ingredients
	o.ingredientsGrid = {}
	for x = 1, ingredients_wide do
		o.ingredientsGrid[x] = {}
		for y = 0, ingredients_high do
			if (y==0) then
				o.ingredientsGrid[x][y] = 1
			else
				o.ingredientsGrid[x][y] = gem.new(0, (x - 1) * ingredient.ingredientWidth + o.offsetX, (y - 1) * ingredient.ingredientHeight + o.offsetY)
			end
		end
	end
end

-- Handle snapping ingredients back into position
--[[*****!!!!!This is where we will define snapping the ingredient back into its
original position if not dropped into staging area!!!!!*****--]]

-- Lock ingredient into place in staging area
--[[*****!!!!!This is where we will lock an ingredient into place in the
staging area!!!!!*****--]]
