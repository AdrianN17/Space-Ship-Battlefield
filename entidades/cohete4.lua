local Class = require "libs.class"
local HC = require "libs.HC"
local Entity= require "entidades.Entity"
local Base = require "nivel.Base"
local rocket = require "entidades.rocket"
local astronauta = require "entidades.astronauta"
local turret = require "entidades.turret"
local cohete4= Class{
	__includes = Entity
}

function cohete4:init(x,y,r)
	self.type="cohete"
	self.id="enemy"

	self.x,self.y=x,y
	self.radio=math.rad(r)
	self.speed=350

	self.img,self.img2,self.quad=imgs["cohete"],imgs["objeto"],quads["cohete4"]

	self.body={}

	self.body[1]=HC.polygon(self.x,self.y,self.x+11,self.y-49,self.x+34,self.y-78,self.x+55,self.y-49,self.x+68,self.y,self.x+68,self.y+192,self.x+65,self.y+201,self.x+70,self.y+212,self.x+67,self.y+228,self.x+63,self.y+237,self.x+4,self.y+237,self.x-1,self.y+228,self.x-4,self.y+212,self.x+1,self.y+201,self.x,self.y+192)

	self.ox,self.oy=self.body[1]:center()
	self.body[2]=HC.point(self.ox,self.oy+65)
	self.body[3]=HC.rectangle(self.x-36,self.y+23,36,160)
	self.body[4]=HC.rectangle(self.x+68,self.y+23,36,160)


	
	self.ox1,self.oy1=self.body[2]:center()

	self.radio1,self.radio2=0,0

	self.maxb=4

	self.hp=20

	self.time=0
	self.time1=0
	self.time2=0
	self.radio1,self.radiomov2=0,0
	self.radio1,self.radiomov2=0,0

end

function cohete4:draw()
	if self.hp>=1 then
		love.graphics.draw(self.img,self.quad[1],self.ox,self.oy,self.radio,1,1,34,64*1.5+78-5)
		love.graphics.draw(self.img,self.quad[2],self.ox,self.oy,self.radio,1,1,34,64*1.5-5)
		love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio,1,1,34,64/2-5)
		love.graphics.draw(self.img,self.quad[4],self.ox,self.oy,self.radio,1,1,34,-32-5)
		love.graphics.draw(self.img,self.quad[5],self.ox,self.oy,self.radio,1,1,34+3,-32-64-5)
	end
	if self.hp>=16 then
		love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio,1,1,-34,75-5)
	end
	if self.hp>=11 then
		love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio,-1,1,-34,75-5)
	end

	love.graphics.draw(self.img2,self.quad[7],self.ox,self.oy,self.radio,1,1,21,21)
	love.graphics.draw(self.img2,self.quad[8],self.ox,self.oy,self.radio1,1,-1,13,28.5)

	love.graphics.draw(self.img2,self.quad[7],self.ox,self.oy,self.radio,1,1,21,21-65)
	love.graphics.draw(self.img2,self.quad[9],self.ox1,self.oy1,self.radio2,1,-1,13,28.5)

	--[[for i,b in ipairs(self.body) do
		b:draw("line")
	end]]

end

function cohete4:update(dt,xp,yp)
	local x,y=math.sin(self.radio)*dt*self.speed,-math.cos(self.radio)*dt*self.speed

	self.time1=self.time1+dt
	self.time2=self.time2+dt

	self.radiomov1=math.atan2(yp-self.oy,xp-self.ox)
	self.radio1=math.rad(-90)+self.radiomov1

	self.radiomov2=math.atan2(yp-self.oy1,xp-self.ox1)
	self.radio2=math.rad(-90)+self.radiomov2

	if self.hp<16 then
		self.maxb=3
		self.speed=250
		if self.body[4]~=nil then
			HC.remove(self.body[4])
		end
	end
	if self.hp<11 then
		self.maxb=2
		self.speed=150
		if self.body[3]~=nil then
			HC.remove(self.body[3])
		end
	end

	if self.time1>2.5 then
		self.time1=0
		sound[3]:play()
		Base.Entities:add(rocket(self.ox-6,self.oy-12.5,self.radio1,self.radiomov1+math.rad(5),1000,self.id))
		Base.Entities:add(rocket(self.ox-6,self.oy-12.5,self.radio1,self.radiomov1-math.rad(5),1000,self.id))
	end

	if self.time2>3.5 then
		self.time2=0
		sound[3]:play()
		Base.Entities:add(rocket(self.ox1-6,self.oy1-12.5,self.radio2,self.radiomov2+math.rad(5),1000,self.id))
		Base.Entities:add(rocket(self.ox1-6,self.oy1-12.5,self.radio2,self.radiomov2-math.rad(5),1000,self.id))
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
		score=score+500
		Base.Entities:remove(self)
	end

	self.ox,self.oy=self.body[1]:center()
	self.ox1,self.oy1=self.body[2]:center()

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
end

function cohete4:col(entidad)
	for i=1,self.maxb,1 do
		if self.body[i]:collidesWith(entidad.body) and self.id~=entidad.id then
			return true
		end
	end
end

return cohete4