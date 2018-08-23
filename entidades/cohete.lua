local Class = require "libs.class"
local HC = require "libs.HC"
local Entity= require "entidades.Entity"
local Base = require "nivel.Base"
local astronauta = require "entidades.astronauta"
local turret = require "entidades.turret"
local cohete = Class{
	__includes = Entity
}

function cohete:init(x,y,r)
	self.type="cohete"
	self.id="enemy"
	self.x,self.y=x,y
	
	self.img,self.quad=imgs["cohete"],quads["cohete1"]

	self.body={}
	self.body[1]=HC.polygon(self.x+34,self.y,self.x+56,self.y+20,self.x+56,self.y+45,self.x+68,self.y+58,self.x+68,self.y+370,self.x,self.y+370,self.x,self.y+58,self.x+12,self.y+45,self.x+12,self.y+20)

	self.body[2]=HC.polygon(self.x-37,self.y+320,self.x,self.y-55+320,self.x, self.y-3+320,self.x-37, self.y+32+323)
	self.body[3]=HC.polygon(self.x+68,self.y-55+320,self.x+68+37,self.y+320,self.x+68+37, self.y+32+323,self.x+68, self.y-3+320 )

	
	
	self.radio=math.rad(r)
	self.ox,self.oy=self.body[1]:center()

	self.inclinacion=math.rad(45)
	--radio maximo y minimo
	self.rmax,self.rmin=self.radio+self.inclinacion,self.radio-self.inclinacion
	self.medidor=0
	self.postura=true
	
	self.hp=20
	self.speed=200

	self.maxb=3

	
end

function cohete:draw()
	if self.hp>=1 then
		love.graphics.draw(self.img,self.quad[1],self.ox,self.oy,self.radio,1,1,34,196.7)
		love.graphics.draw(self.img,self.quad[2],self.ox,self.oy,self.radio,1,1,34,123.7)
		love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio,1,1,34,59.7)
		love.graphics.draw(self.img,self.quad[4],self.ox,self.oy,self.radio,1,1,34,-4.3)
		love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio,1,1,34,-68.3)
		love.graphics.draw(self.img,self.quad[5],self.ox,self.oy,self.radio,1,1,34,-132.3)
	end

	if self.hp>=16 then
		love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio,1,1,-34,-68.3)
	end

	if self.hp>=11 then
		love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio,-1,1,-34,-68.3)
	end

	--[[for i,b in ipairs(self.body) do
		b:draw("line")
	end]]
	
end

function cohete:update(dt)
	local x,y=math.sin(self.radio)*dt*self.speed,-math.cos(self.radio)*dt*self.speed

	if self.hp<16 then
		self.maxb=2
		self.medidor=1
		if self.body[3]~=nil then
			HC.remove(self.body[3])
		end
	end
	if self.hp<11 then
		self.maxb=1
		self.medidor=-1
		self.speed=50
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
	

	if self.medidor==1 then
		if self.radio>self.rmax and self.postura then
			self.postura=false
		elseif self.radio<self.rmin and not self.postura then
			self.postura=true
		end
	end

	if self.postura and self.medidor==1  then
		self.radio=self.radio+self.inclinacion*dt
	elseif not self.postura and self.medidor==1 then
		self.radio=self.radio-self.inclinacion*dt
	end
	self.ox,self.oy=self.body[1]:center()

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
	
	
end

function cohete:col(entidad)
	
	for i=1,self.maxb,1 do
		if self.body[i]:collidesWith(entidad.body) and self.id~=entidad.id then
			return true
		end
	end
end

return cohete