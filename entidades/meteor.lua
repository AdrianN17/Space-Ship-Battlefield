local Class = require "libs.class"
local HC = require "libs.HC"
local Base = require "nivel.Base"
local Entity= require "entidades.Entity"
local meteor = Class{
	__includes = Entity
}
	
function meteor:init(x,y,scale,r,speed)
	self.type="meteor"
	self.id="enemy"
	self.scale=scale
	self.x,self.y=x,y
	self.img,self.quad=imgs["meteoro"],quads["meteoro"]
	self.body=HC.circle(self.x,self.y,120*self.scale)
	self.hp=5
	self.time=0
	self.radio=0
	self.radiomov=math.rad(r)
	self.ox,self.oy=self.body:center()

	if speed==nil then
		self.speed=50
	else
		self.speed=speed
	end
end

function meteor:draw()
	love.graphics.draw(self.img,self.quad,self.ox,self.oy,self.radio,-self.scale,-self.scale,107,113.5)
	--self.body:draw("line")
end

function meteor:update(dt)
	local x,y=math.sin(self.radiomov)*dt*self.speed,-math.cos(self.radiomov)*dt*self.speed

	self.time=self.time+dt

	if self.time>0.3 then
		self.radio=self.radio+math.pi*dt*10
		self.time=0
	end

	self.body:move(x,y)

	
	if self.hp<1 then
		if self.scale==1 then
			for i=1,love.math.random(1,5),1 do
				Base.Entities:add(meteor(self.ox,self.oy,0.5,love.math.random(1,360),love.math.random(100,150)))
			end
		end
		score=score+150*self.scale

		Base.Entities:remove(self)
	end

	self.ox,self.oy=self.body:center()

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
end

function meteor:col(entidad)
	if self.body:collidesWith(entidad.body) and self.id~=entidad.id then
		return true
	end
end

return meteor