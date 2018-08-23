local Class = require "libs.class"
local HC = require "libs.HC"
local Entity= require "entidades.Entity"
local Base = require "nivel.Base"
local astronauta = require "entidades.astronauta"
local turret = require "entidades.turret"
local station = Class{
	__includes = Entity
}

function station:init(x,y)
	self.type="station"
	self.id="enemy"
	self.x,self.y=x,y
	self.img,self.img2,self.quad=imgs["torres"],imgs["laser"],quads["station"]
	self.body={}

	self.body[1]=HC.rectangle(self.x+56,self.y-86,60,86)
	self.body[2]=HC.rectangle(self.x,self.y,172,53)
	self.body[3]=HC.rectangle(self.x+64,self.y+53,44,26)
	self.body[4]=HC.rectangle(self.x+44,self.y+79,84,36)
	self.body[5]=HC.polygon(self.x+65,self.y+115, self.x+107,self.y+115, self.x+99,self.y+197, self.x+70, self.y+197)

	self.point=HC.point(self.x+86,self.y+240)

	self.points={}

	for i=0,1120,20 do --56
		table.insert(self.points,HC.point(self.x+86,self.y+250+i))
	end



	self.radio=0

	self.px,self.py=self.point:center()

	self.hp=20

	self.r=0

	self.d=2
	self.time=0
	self.crecer=true
	self.sx=1
	self.sy=20

	self.v=0.2

end

function station:draw()


	love.graphics.draw(self.img,self.quad[1],self.ox,self.oy,self.radio,1,1,30,112)
	love.graphics.draw(self.img,self.quad[2],self.ox,self.oy,self.radio+math.rad(90),1,1,75,22)
	love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio,1,1,86,26)
	love.graphics.draw(self.img,self.quad[4],self.ox,self.oy,self.radio-math.rad(90),1,1,52,22)
	love.graphics.draw(self.img,self.quad[5],self.ox,self.oy,self.radio,1,1,42,-52)
	love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio+math.rad(90),1,1,-88,21)




	--[[for i,b in ipairs(self.body) do
		b:draw("line")
	end

		

	for i, p in ipairs(self.points) do
		p:draw("line")
	end]]

	love.graphics.draw(self.img2,self.quad[8],self.px,self.py,self.radio,self.sx,self.sy,9/2,0)

	love.graphics.draw(self.img2,self.quad[7],self.px,self.py,self.r,2,2,48/2,46/2)

	--love.graphics.print(self.hp,200,400,0,4,4)
end

function station:update(dt,x,y)

	self.ox,self.oy=self.body[2]:center()

	self.time=self.time+dt

	if self.time>7 then
		self.d=self.d*-1
		self.time=0
	end

	if self.sx <1 then
		self.crecer=true
	elseif self.sx >15 then
		self.crecer=false
	end
	

	if self.crecer then
		self.sx=self.sx+self.sx*dt
		for i=3,56,2 do
			self.points[i]:move(math.cos(self.radio)*self.v,math.sin(self.radio)*self.v)
		end 
		for i=2,56,2 do
			self.points[i]:move(math.cos(self.radio)*-self.v,math.sin(self.radio)*-self.v)
		end

	else
		self.sx=self.sx-self.sx*dt
		for i=3,56,2 do
			self.points[i]:move(math.cos(self.radio)*-self.v,math.sin(self.radio)*-self.v)
		end 
		for i=2,56,2 do
			self.points[i]:move(math.cos(self.radio)*self.v,math.sin(self.radio)*self.v)
		end
	end



	self.radio=self.radio+math.rad(self.d)

	for i,b in ipairs (self.body) do
		b:setRotation(self.radio,self.body[2]:center())
	end

	for i,p in ipairs(self.points) do
		p:setRotation(self.radio,self.body[2]:center())
	end



	self.r=self.r+math.rad(5)

	self.point:setRotation(self.radio,self.body[2]:center())
	self.px,self.py=self.point:center()

	if self.hp<1 then
		local azar= love.math.random(1,10)
		local azar2= love.math.random(0,3)
		for i=1, azar, 1 do
			Base.Entities:add(astronauta(self.ox+love.math.random(-300,300),self.oy+love.math.random(-300,300)))
		end
		for i=1, azar2,1 do
			Base.Entities:add(turret(self.ox+love.math.random(-200,200),self.oy+love.math.random(-200,200)))
		end

		score=score+1000
		
		Base.Entities:remove(self)
	end

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end

end

function station:col(entidad)
	for i, b in ipairs(self.body) do
		if b:collidesWith(entidad.body) and self.id~=entidad.id then
			return true
		end
	end

	for i, p in ipairs(self.points)  do
		if p:collidesWith(entidad.body) and self.id~=entidad.id then
			return true, 1
		end
	end
end

return station