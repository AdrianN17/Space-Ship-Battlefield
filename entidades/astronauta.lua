local Class = require "libs.class"
local HC = require "libs.HC"
local Base = require "nivel.Base"
local laser = require "entidades.laser"
local Entity= require "entidades.Entity"
local astronauta = Class{
	__includes = Entity
}

function astronauta:init(x,y)
	self.type="astronauta"
	self.id="enemy"
	self.x,self.y=x,y

	self.img,self.quad=imgs["astronauta"],quads["astronauta"]
	
	self.body=HC.circle(self.x+37/2,self.y+22,22)
	self.it=1
	self.radio=math.rad(0)
	self.ox,self.oy=self.body:center()

	self.w={17,18.5,20}
	self.time=0

	self.hp=1
end

function astronauta:draw()
	love.graphics.draw(self.img,self.quad[self.it],self.ox,self.oy,self.radio,1,1,self.w[self.it],22)
	--self.body:draw("line")
end

function astronauta:update(dt,x,y)
	self.ox,self.oy=self.body:center()
	self.it=3
	self.radio=math.atan2(y-self.oy,x-self.ox)

	self.time=self.time+dt

	if self.time>3 then
		self.time=0
		sound[1]:play()
		Base.Entities:add(laser(self.ox-6.5,self.oy-27,self.radio,math.rad(-90)+self.radio,self.id))
	end

	if self.hp<1 then
		score=score+50
		Base.Entities:remove(self)
	end

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
end

function astronauta:col(entidad)
	if self.body:collidesWith(entidad.body) and self.id~=entidad.id then
		return true
	end
end

return astronauta