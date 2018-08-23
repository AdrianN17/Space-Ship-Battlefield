local Class = require "libs.class"
local HC = require "libs.HC"
local Entity= require "entidades.Entity"
local Base = require "nivel.Base"
local rocket = require "entidades.rocket"
local astronauta = require "entidades.astronauta"
local turret = require "entidades.turret"
local cohete3 = Class{
	__includes = Entity
}

function cohete3:init(x,y,r)
	self.type="cohete"
	self.id="enemy"
	self.x,self.y=x,y
	self.img=love.graphics.newImage("assets/partes2.png")
	self.img2=love.graphics.newImage("assets/objetos.png")

	self.img,self.img2,self.quad=imgs["cohete"],imgs["objeto"],quads["cohete3"]

	self.body={}
	self.body[1]=HC.polygon(self.x+0,self.y+0,self.x+4,self.y-20,self.x+17,self.y-56,self.x+34,self.y-76,self.x+51,self.y-56,self.x+64,self.y-20,self.x+68,self.y,self.x+68	,self.y+196	,self.x+51,self.y+234,self.x+17,self.y+234,self.x+0,self.y+196)
	self.ox,self.oy=self.body[1]:center()
	self.body[2]=HC.point(self.ox,self.oy-55)
	self.body[3]=HC.point(self.ox,self.oy+75)
	self.body[4]=HC.polygon(self.x-47,self.y+170,self.x	,self.y+97,self.x,self.y+182)
	self.body[5]=HC.polygon(self.x+115,self.y+170,self.x+68,self.y+97,self.x+68,self.y+182)

	self.radio=math.rad(r)
	self.hp=20
	self.speed=250

	self.time=0
	self.time1=0
	self.time2=0


	self.radio1,self.radiomov1=0,0
	self.radio2,self.radiomov2=0,0

	self.maxb=5

	self.inclinacion=math.rad(45)
	--radio maximo y minimo
	self.rmax,self.rmin=self.radio+self.inclinacion,self.radio-self.inclinacion
	self.medidor=0
	self.postura=true

	self.ox2,self.oy2=self.body[2]:center()
	self.ox3,self.oy3=self.body[3]:center()
end


function cohete3:draw()
	if self.hp>=1 then
		love.graphics.draw(self.img,self.quad[1],self.ox,self.oy,self.radio,1,1,34,174-11)
		love.graphics.draw(self.img,self.quad[2],self.ox,self.oy,self.radio,1,1,34,96-11)
		love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio,1,1,34,32-11)
		love.graphics.draw(self.img,self.quad[4],self.ox,self.oy,self.radio,1,1,34,-32-11)
		love.graphics.draw(self.img,self.quad[5],self.ox,self.oy,self.radio,1,1,34,-96-11)
	end

	if self.hp>=11 then
		love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio,-1,1,-34,-10)
	end

	if self.hp>=16 then
		love.graphics.draw(self.img,self.quad[6],self.ox,self.oy,self.radio,1,1,-34,-10)
	end

		love.graphics.draw(self.img2,self.quad[7],self.ox,self.oy,self.radio,1,1,21,21+55)

		love.graphics.draw(self.img2,self.quad[8],self.ox2,self.oy2,self.radio1,1,-1,8.5,28.5)

		love.graphics.draw(self.img2,self.quad[7],self.ox,self.oy,self.radio,1,1,21,21-75)

		love.graphics.draw(self.img2,self.quad[8],self.ox3,self.oy3,self.radio2,1,-1,8.5,28.5)

	--[[for i,b in ipairs(self.body) do
		b:draw("line")
	end]]


end

function cohete3:update(dt,xp,yp)
	local x,y=math.sin(self.radio)*dt*self.speed,-math.cos(self.radio)*dt*self.speed

	self.time1=self.time1+dt
	self.time2=self.time2+dt

	self.radiomov1=math.atan2(yp- self.oy2,xp- self.ox2)
	self.radio1=math.rad(-90)+self.radiomov1

	self.radiomov2=math.atan2(yp- self.oy3,xp- self.ox3)
	self.radio2=math.rad(-90)+self.radiomov2


	if self.hp<16 then
		self.maxb=4
		self.medidor=1
		if self.body[5]~=nil then
			HC.remove(self.body[5])
		end
	end
	if self.hp<11 then
		self.maxb=3
		self.medidor=-1
		self.speed=100
		if self.body[4]~=nil then
			HC.remove(self.body[4])
		end
	end

	for i=1,self.maxb,1 do
		self.body[i]:move(x,y)
		self.body[i]:setRotation(self.radio,self.body[1]:center())
	end


	if self.time1>2.5 then
		self.time1=0
		sound[3]:play()
		Base.Entities:add(rocket(self.ox2-6,self.oy2-12.5,self.radio1,self.radiomov1,1000,self.id))
	end

	if self.time2>3.5 then
		self.time2=0
		sound[3]:play()
		Base.Entities:add(rocket(self.ox3-6,self.oy3-12.5,self.radio2,self.radiomov2,1000,self.id))
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

	if self.medidor==1 then
		if self.radio>self.rmax and self.postura then
			self.postura=false
		elseif self.radio<self.rmin and not self.postura then
			self.postura=true
		end
	end

	if self.postura and self.medidor==1  then
		self.radio=self.radio+self.inclinacion*dt/2
	elseif not self.postura and self.medidor==1 then
		self.radio=self.radio-self.inclinacion*dt/2
	end

	

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end


	self.ox,self.oy=self.body[1]:center()

	self.ox2,self.oy2=self.body[2]:center()
	self.ox3,self.oy3=self.body[3]:center()
end

function cohete3:col(entidad)
	for i=1,self.maxb,1 do
		if self.body[i]:collidesWith(entidad.body) and self.id~=entidad.id then
			return true
		end
	end
end

return cohete3