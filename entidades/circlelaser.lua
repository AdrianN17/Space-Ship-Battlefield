local Class = require "libs.class"
local HC = require "libs.HC"
local rocket = require "entidades.rocket"
local Base = require "nivel.Base"
local Entity= require "entidades.Entity"
local circlelaser = Class{
	__includes = Entity
}

function circlelaser:init(x,y,r)
	self.type="laser"
	self.id="enemy"

	self.x,self.y=x,y

	self.centro=HC.point(self.x,self.y)
	self.body=HC.circle(self.x,self.y-love.math.random(6,10)*10,38)

	
	self.img,self.quad=imgs["laser"],quads["laser"][1]

	self.radio=0
	self.radio2=0
	self.r=r
	self.speed=500

	self.hp=1

	self.ram=love.math.random(10,15)


	self.ox,self.oy=self.body:center()
	self.ox2,self.oy2=self.centro:center()
	self.time=0
end

function circlelaser:draw()

	love.graphics.draw(self.img,self.quad,self.ox,self.oy,self.radio2,2,2,38/2,37/2)

	--self.body:draw()

end

function circlelaser:update(dt)
	local x,y=self.speed*math.cos(self.r)*dt,self.speed*math.sin(self.r)*dt

	self.time=self.time+dt

	self.radio=self.radio+math.rad(self.ram)

	self.radio2=self.radio2+math.rad(self.ram)

	self.body:move(x,y)
	self.centro:move(x,y)

	self.body:setRotation(self.radio,self.centro:center())

	self.ox,self.oy=self.body:center()
	self.ox2,self.oy2=self.centro:center()

	if self.time>3 then
		Base.Entities:remove(self)
	end

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
end

function circlelaser:col(entidad)
	if self.body:collidesWith(entidad.body) and self.id~=entidad.id then
		return true
	end
end

return circlelaser