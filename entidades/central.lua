local Class = require "libs.class"
local HC = require "libs.HC"
local Base = require "nivel.Base"
local Entity= require "entidades.Entity"
local astronauta = require "entidades.astronauta"
local central = Class{
	__includes = Entity
}

function central:init(x,y)
	self.type="central"
	self.id="enemy"
	self.x,self.y=x,y
	self.radio=0

	self.img,self.quad=imgs["torres"],quads["central"]



	self.body={}
	self.body[1]=HC.rectangle(self.x,self.y,40,40)
	self.body[2]=HC.rectangle(self.x+40,self.y-2,32,44)
	self.body[3]=HC.rectangle(self.x+72,self.y+6,40,28)
	self.body[4]=HC.rectangle(self.x+72+40,self.y,42,44)

	self.body[5]=HC.rectangle(self.x-2,self.y+40,44,32)
	self.body[6]=HC.rectangle(self.x+6,self.y+40+32,28,40)
	self.body[7]=HC.rectangle(self.x-3,self.y+40+32+40,44,56)
	self.body[8]=HC.rectangle(self.x-3,self.y+40+40+56+32,44,32)
	self.body[9]=HC.rectangle(self.x-3,self.y+40+40+56+32+32,44,122)

	self.body[10]=HC.rectangle(self.x-32,self.y-2,32,44)
	self.body[11]=HC.rectangle(self.x-32-40,self.y+6,40,28)
	self.body[12]=HC.rectangle(self.x-32-40-24,self.y-2,24,44)
	self.body[13]=HC.rectangle(self.x-32-40-24-42,self.y-2,42,44)

	self.body[14]=HC.rectangle(self.x-2,self.y-48,44,48)
	self.body[15]=HC.rectangle(self.x-6,self.y-48-34,52,34)


	self.hp=160
	self.maxb=15

	self.ox,self.oy=self.body[1]:center()

	self.radio={}
	for i=1,15,1 do
		self.radio[i]=0
	end
end

function central:draw()

	if self.maxb>=1 then 
		love.graphics.draw(self.img,self.quad[5],self.ox,self.oy,self.radio[2],1,1,20,20)
	end


	if self.maxb>=2 then 
		love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio[2],1,1,-20,22)
	end
	if self.maxb>=3 then 
		love.graphics.draw(self.img,self.quad[7],self.ox,self.oy,self.radio[3],1,1,-52,14)
	end
	if self.maxb>=4 then 
		love.graphics.draw(self.img,self.quad[8],self.ox,self.oy,self.radio[4],1,1,-92,20)
	end
	if self.maxb>=5 then 
		love.graphics.draw(self.img,self.quad[11],self.ox,self.oy,self.radio[5]-math.rad(-90),1,1,-20,22)
	end
	if self.maxb>=6 then 
		love.graphics.draw(self.img,self.quad[12],self.ox,self.oy,self.radio[6]-math.rad(-90),1,1,-52,14)
	end
	if self.maxb>=7 then 
		love.graphics.draw(self.img,self.quad[13],self.ox,self.oy,self.radio[7]-math.rad(90),1,1,92+56,23)
	end
	if self.maxb>=8 then 
		love.graphics.draw(self.img,self.quad[14],self.ox,self.oy,self.radio[8]-math.rad(90),1,1,92+56+32,23)
	end
	if self.maxb>=9 then 
		love.graphics.draw(self.img,self.quad[15],self.ox,self.oy,self.radio[9]-math.rad(-90),1,1,-92-56-32,21)
	end
	if self.maxb>=10 then 
		love.graphics.draw(self.img,self.quad[4],self.ox,self.oy,self.radio[10],1,1,52,22)
	end
	if self.maxb>=11 then 
		love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio[11],1,1,92,14)
	end
	if self.maxb>=12 then 
		love.graphics.draw(self.img,self.quad[2],self.ox,self.oy,self.radio[12],1,1,92+24,22)
	end
	if self.maxb>=13 then 
		love.graphics.draw(self.img,self.quad[1],self.ox,self.oy,self.radio[13],1,1,92+24+42,22)
	end
	if self.maxb>=14 then 
		love.graphics.draw(self.img,self.quad[9],self.ox,self.oy,self.radio[14]-math.rad(90),1,1,-20,22)
	end
	if self.maxb>=15 then 
		love.graphics.draw(self.img,self.quad[10],self.ox,self.oy,self.radio[15],1,1,26,68+34)
	end


	--[[for i,b in ipairs(self.body) do
		b:draw("line")
	end]]



end

function central:update(dt)

	--self.radio[1]=self.radio[1]+dt/7

	if math.floor(self.hp/10)<self.maxb then
		self.maxb=self.maxb-1

		local azar= love.math.random(1,10)
		for i=1, azar, 1 do
			Base.Entities:add(astronauta(self.ox+love.math.random(-300,300),self.oy+love.math.random(-300,300)))
		end
	end

		
	for i=1,self.maxb,1 do
		self.body[i]:setRotation(self.radio[1],self.body[1]:center())
		self.radio[i]=self.radio[1]
	end


	if self.hp<1 then
		score=score+2000
		Base.Entities:remove(self)
	end

	self.ox,self.oy=self.body[1]:center()

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
end

function central:col(entidad)
	for i=1,self.maxb,1 do
		if self.body[i]:collidesWith(entidad.body) and self.id~=entidad.id then
			return true
		end
	end
end

return central