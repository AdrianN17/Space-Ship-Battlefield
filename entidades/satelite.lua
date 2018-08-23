local Class = require "libs.class"
local HC = require "libs.HC"
local Entity= require "entidades.Entity"
local Base = require "nivel.Base"
local satelite = Class{
	__includes = Entity
}

function satelite:init(x,y)
	self.type="satelite"
	self.id="enemy"
	self.x,self.y=x,y

	self.img,self.quad=imgs["objeto"],quads["satelite"]

	self.body=HC.rectangle(self.x,self.y,168,40)
	self.radio=0
	self.time=0
	self.hp=2
	self.ox,self.oy=self.body:center()
end

function satelite:draw()
	love.graphics.draw(self.img,self.quad,self.ox,self.oy,self.radio,-1,-1,84,20)
	--self.body:draw("line")
end

function satelite:update(dt)
	self.time=self.time+dt

	if self.time>0.3 then
		self.radio=self.radio+math.pi*dt*2
		self.time=0
	end
	self.body:setRotation(self.radio)

	if self.hp<1 then
		score=score+150
		Base.Entities:remove(self)
	end

	self.ox,self.oy=self.body:center()

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
end

function satelite:col(entidad)
	if self.body:collidesWith(entidad.body) and self.id~=entidad.id then
		return true
	end
end

return satelite