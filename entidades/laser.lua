local Class = require "libs.class"
local HC = require "libs.HC"
local Base = require "nivel.Base"
local Entity= require "entidades.Entity"
local laser = Class{
	__includes = Entity
}

function laser:init(x,y,r,rm,id)
	self.type="laser"
	self.id=id
	self.x,self.y=x,y
	self.r,self.rm=r,rm

	self.img,self.quad=imgs["laser"],quads["laser"][2]

	self.body=HC.point(self.x+13/2,self.y+54/2)
	self.speed=2000
	self.time=0
	self.ox,self.oy=self.body:center()
	self.hp=1
end

function laser:draw()
	love.graphics.draw(self.img,self.quad,self.ox,self.oy,self.rm,-1,-1,6.5,27)
	--self.body:draw("line")
end

function laser:update(dt)
	local x,y=self.speed*math.cos(self.r)*dt,self.speed*math.sin(self.r)*dt
	self.time=self.time+dt

	self.body:move(x,y)
	self.body:setRotation(self.rm)
	self.ox,self.oy=self.body:center()



	if self.time>2 or self.hp<1 then
		Base.Entities:remove(self)
	end

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
end

function laser:col(entidad)
	if self.body:collidesWith(entidad.body) and self.id~=entidad.id then
		return true
	end
end

return laser