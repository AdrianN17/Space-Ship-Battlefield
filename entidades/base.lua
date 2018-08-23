local Class = require "libs.class"
local HC = require "libs.HC"
local Base = require "nivel.Base"
local Entity= require "entidades.Entity"
local circlelaser= require "entidades.circlelaser"
local astronauta = require "entidades.astronauta"
local base = Class{
	__includes = Entity
}

function base:init(x,y)
	self.type="base"
	self.id="enemy"
	self.x,self.y=x,y
	self.radio=0

	self.img,self.quad=imgs["torres"],quads["base"]

	self.body={}

	self.body[1]=HC.rectangle(self.x-40,self.y-40-36-58,124,58)
	self.body[2]=HC.rectangle(self.x-20,self.y-40-36,84,36)
	self.body[3]=HC.rectangle(self.x+8,self.y-40,28,40)
	self.body[4]=HC.rectangle(self.x,self.y,44,32)
	self.body[5]=HC.rectangle(self.x,self.y+32,44,122)
	self.body[6]=HC.rectangle(self.x+14,self.y+32+122,16,66)

	--self.body[2]=HC.rectangle(self.x,self.y,44,32)

	self.ox,self.oy=self.body[4]:center()

	self.maxb=6

	self.hp=40

	self.time=0
end

function base:draw()
	love.graphics.draw(self.img,self.quad[1],self.ox,self.oy,self.radio,1,1,62,40+36+16+58)
	love.graphics.draw(self.img,self.quad[2],self.ox,self.oy,self.radio,1,1,42,40+36+16)
	love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio-math.rad(90),1,1,-16,14)
	love.graphics.draw(self.img,self.quad[4],self.ox,self.oy,self.radio-math.rad(-90),1,1,16,22)
	love.graphics.draw(self.img,self.quad[5],self.ox,self.oy,self.radio-math.rad(-90),1,1,-16,22)
	love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio,1,-1,8,204)


	--[[for i,b in ipairs(self.body) do
		b:draw("line")
	end]]

end

function base:update(dt,x,y)
	self.time=self.time+dt

	for i=1,self.maxb,1 do
		self.body[i]:setRotation(self.radio,self.body[4]:center())
		--self.body[i]:move(x,y)
	end

	if self.time>3.5 then
		local r=math.atan2(y-(self.oy+350),x-self.ox)
		sound[2]:play()
		Base.Entities:add(circlelaser(self.ox,self.oy+350,r-math.rad(25)))
		Base.Entities:add(circlelaser(self.ox,self.oy+350,r))
		Base.Entities:add(circlelaser(self.ox,self.oy+350,r+math.rad(25)))
		self.time=0
	end
	self.ox,self.oy=self.body[4]:center()

	if self.hp<1 then
		score=score+700
		local azar= love.math.random(1,10)
		for i=1, azar, 1 do
			Base.Entities:add(astronauta(self.ox+love.math.random(-300,300),self.oy+love.math.random(-300,300)))
		end
		Base.Entities:remove(self)
	end

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end

end

function base:col(entidad)
	for i=1,self.maxb,1 do
		if self.body[i]:collidesWith(entidad.body) and self.id~=entidad.id then
			return true
		end
	end
end

return base