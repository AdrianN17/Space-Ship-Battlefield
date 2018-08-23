-- Represents a single drawable object
local Class = require 'libs.class'

local Entity = Class{}

function Entity:init(x,y)
	-- Do nothing by default, but we still have to have something to call
end

function Entity:draw()
  -- Do nothing by default, but we still have to have something to call
end

function Entity:update(dt)

  -- Do nothing by default, but we still have to have something to call 
end

function Entity:keypressed(key,isrepeat)
  -- Do nothing by default, but we still have to have something to call
end

function Entity:keyreleased(key)
  -- Do nothing by default, but we still have to have something to call
end

function Entity:mousepressed(x, y, button)
  -- Do nothing by default, but we still have to have something to call
end

function Entity:mousereleased(x, y, button)
  -- Do nothing by default, but we still have to have something to call
end

return Entity