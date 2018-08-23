local Class = require "libs.class"
local HC = require "libs.HC"
local Entity= require "entidades.Entity"
local Base = require "nivel.Base"
local astronauta = require "entidades.astronauta"
local turret = require "entidades.turret"
local cohete2 = Class{
	__includes = Entity
}

function cohete2:init(x,y,r)
	self.type="cohete"
	self.id="enemy"
	self.x,self.y=x,y
	self.img=love.graphics.newImage("assets/partes2.png")
	self.img2=love.graphics.newImage("assets/objetos.png")

	self.img,self.quad=imgs["cohete"],quads["cohete2"]

	self.body={}
	self.body[1]=HC.polygon(self.x,self.y-128,self.x+10,self.y-170,self.x+34,self.y-206,self.x+58,self.y-170,self.x+68,self.y-128,self.x+68,self.y+128,self.x+51,self.y+168,self.x+17,self.y+168,self.x,self.y+128)
	self.body[2]=HC.rectangle(self.x+19.5,self.y-25,29,170)
	self.body[3]=HC.rectangle(self.x+68,self.y,29,170)
	self.body[4]=HC.rectangle(self.x-29,self.y,29,170)
	
	
	self.maxb=4

	self.ox,self.oy=self.body[1]:center()

	self.radio=math.rad(r)
	self.hp=25
	self.speed=350
end

function cohete2:draw()

	if self.hp>=1 then
		love.graphics.draw(self.img,self.quad[1],self.ox,self.oy,self.radio,1,1,34,196.3)
		love.graphics.draw(self.img,self.quad[2],self.ox,self.oy,self.radio,1,1,34,118.3)
		love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio,1,1,34,54.3)
		love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio,1,1,34,-9.7)
		love.graphics.draw(self.img,self.quad[4],self.ox,self.oy,self.radio,1,1,34,-73.7)
		love.graphics.draw(self.img,self.quad[5],self.ox,self.oy,self.radio,1,1,34,-137.7)
	end

	if self.hp>=21 then
		love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio,1,1,63,-9.7)
	end

	if self.hp>=16 then
		love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio,1,1,-34,-9.7)
	end

	if self.hp>=11 then
		love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio,1,1,14.5,15.3)
	end

	--[[for i,b in ipairs(self.body) do
		b:draw("line")
	end]]


end

function cohete2:update(dt)
	local x,y=math.sin(self.radio)*dt*self.speed,-math.cos(self.radio)*dt*self.speed

	if self.hp<21 then
		self.maxb=3
		self.speed=250
		if self.body[4]~=nil then
			HC.remove(self.body[4])
		end
	end

	if self.hp<16 then
		self.maxb=2
		self.speed=200
		if self.body[3]~=nil then
			HC.remove(self.body[3])
		end
	end

	if self.hp<11 then
		self.maxb=1
		self.speed=100
		if self.body[2]~=nil then
			HC.remove(self.body[2])
		end
	end


	for i=1,self.maxb,1 do
		self.body[i]:move(x,y)
		self.body[i]:setRotation(self.radio,self.body[1]:center())
	end


	if self.hp<1 then
		local azar= love.math.random(1,10)
		local azar2= love.math.random(0,3)
		for i=1, azar, 1 do
			Base.Entities:add(astronauta(self.ox+love.math.random(-300,300),self.oy+love.math.random(-300,300)))
		end
		for i=1, azar2,1 do
			Base.Entities:add(turret(self.ox+love.math.random(-200,200),self.oy+love.math.random(-200,200)))
		end
		score=score+400
		Base.Entities:remove(self)
	end

	self.ox,self.oy=self.body[1]:center()

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
	
end

function cohete2:col(entidad)
	for i=1,self.maxb,1 do
		if self.body[i]:collidesWith(entidad.body) and self.id~=entidad.id then
			return true
		end
	end
end

return cohete2