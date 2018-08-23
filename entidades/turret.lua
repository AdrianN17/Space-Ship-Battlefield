local Class = require "libs.class"
local HC = require "libs.HC"
local Base = require "nivel.Base"
local rocket = require "entidades.rocket"
local Entity= require "entidades.Entity"
local turret = Class{
	__includes = Entity
}

function turret:init(x,y)
	self.type="turret"
	self.id="enemy"
	self.x,self.y=x,y

	self.img,self.quad=imgs["objeto"],quads["turret"]

	self.body=HC.rectangle(self.x,self.y,42,42)
	self.radio=0
	self.radiomov=0
	self.time=0
	self.hp=4
	self.ox,self.oy=self.body:center()
end

function turret:draw()

	love.graphics.draw(self.img,self.quad[1],self.ox,self.oy,0,1,1,21,21)
	love.graphics.draw(self.img,self.quad[2],self.ox, self.oy,self.radio,1,-1,8.5,28.5)
	--self.body:draw("line")

end

function turret:update(dt,x,y)
	self.radiomov=math.atan2(y-self.oy,x-self.ox)
	self.radio=math.rad(-90)+self.radiomov

	self.time=self.time+dt

	if self.time>2 then
		self.time=0
		sound[3]:play()
		Base.Entities:add(rocket(self.ox-6,self.oy-12.5,self.radio,self.radiomov,1000,self.id))
	end

	self.ox,self.oy=self.body:center()

	if self.hp<1 then
		Base.Entities:remove(self)
		score=score+100
	end

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
end

function turret:col(entidad)
	if self.body:collidesWith(entidad.body) and self.id~=entidad.id then
		return true
	end
end



return turret