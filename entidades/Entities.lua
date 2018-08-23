local Entities = {
	entityList = {},
	player=nil
}

function Entities:enter(world)
  self:clear()
end

function Entities:actor(entity)
	player=entity
	table.insert(self.entityList, entity)
end

function Entities:add(entity)
  table.insert(self.entityList, entity)
end

function Entities:addMany(entities)
  for k, entity in pairs(entities) do
    table.insert(self.entityList, entity)
  end
end

function Entities:remove(entity)
	for i, e in ipairs(self.entityList) do
		if e == entity then
      table.remove(self.entityList, i)
			return
		end
	end
end

function Entities:removeAt(index)
	table.remove(self.entityList, index)
end

function Entities:clear()
	self.map = nil
	self.world = nil
	self.entityList = {}
	self.player=nil
end

function Entities:draw()
	--inverso
	for i=#self.entityList,1,-1 do
		self.entityList[i]:draw(i)
	end

	--[[for i, e in ipairs(self.entityList) do
		e:draw(i)
	end]]
end

function Entities:update(dt)
	for i, e in ipairs(self.entityList) do
		e:update(dt,player.ox,player.oy)
	end
end

function Entities:keypressed(key)
  for i, e in ipairs(self.entityList) do
    e:keypressed(key)
  end
end

function Entities:keyreleased(key)
  for i, e in ipairs(self.entityList) do
    e:keyreleased(key)
  end
end

function Entities:mousepressed(x,y,button)
	for i, e in ipairs(self.entityList) do
    e:mousepressed(x,y,button)
  end
end

function Entities:mousereleased(x,y,button)
	for i, e in ipairs(self.entityList) do
    e:mousereleased(x, y, button)
  end
end

return Entities
