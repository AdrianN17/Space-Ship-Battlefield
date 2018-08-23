local Class = require "libs.class"
local rocket = require "entidades.rocket"
local Base = require "nivel.Base"
local HC = require "libs.HC"
local Entity= require "entidades.Entity"
local shipia = Class{
	__includes = Entity
}

function shipia:init(x,y,r)
	self.type="ship_ia"
	self.id="enemy"

	self.x,self.y=x,y

	self.body=HC.rectangle(self.x,self.y,136,84)


	self.img,self.quad=imgs["partes"],quads["shipia"]

	self.hp=5
	self.radiomov=math.rad(r)
	self.radio=self.radiomov+math.rad(-90)

	self.sp=love.math.random(3,5)*100
	self.speed=self.sp
	self.maxsp=self.sp+100

	self.ox,self.oy=self.body:center()

	self.time=0
	self.immunity=false

	self.sensor=HC.circle(self.ox,self.oy+500,500)

	self.body:setRotation(self.radio,self.body:center())
	self.sensor:setRotation(self.radio,self.body:center())

	self.time=0

end

function shipia:draw()
	--self.body:draw("line")

	--self.sensor:draw("line")

	love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio,1,1,-5,42)
	love.graphics.draw(self.img,self.quad[3],self.ox,self.oy,self.radio,-1,1,-5,42)
	love.graphics.draw(self.img,self.quad[1],self.ox,self.oy,self.radio,1,1,45/2,66/2)
	love.graphics.draw(self.img,self.quad[2],self.ox,self.oy,self.radio,1,1,-22,35)
	love.graphics.draw(self.img,self.quad[2],self.ox,self.oy,self.radio,-1,1,-22,35)
	love.graphics.draw(self.img,self.quad[4],self.ox,self.oy,self.radio,1,1,12,0)

end

function shipia:update(dt)
	local x,y=0,0
	local ex,ey=0,0
	local init=false
	for i, lista in ipairs(Base.Entities.entityList) do
		if lista.id=="player" and lista.type=="ship" then
			if self.sensor:collidesWith(lista.body)  then
				ex,ey=lista.x,lista.y
				init=true
			end
		end
	end

	if init then
		self.speed=self.maxsp
		self.radiomov=math.atan2(ey-self.oy,ex-self.ox)
		self.radio=math.rad(-90)+self.radiomov

		self.time=self.time+dt

		if self.time>1 then
			sound[3]:play()
			Base.Entities:add(rocket(self.ox-6,self.oy-12.5,self.radio,self.radiomov+math.rad(5),1000,self.id))
			Base.Entities:add(rocket(self.ox-6,self.oy-12.5,self.radio,self.radiomov,1000,self.id))
			Base.Entities:add(rocket(self.ox-6,self.oy-12.5,self.radio,self.radiomov-math.rad(5),1000,self.id))
			self.time=0
		end
	else
		self.time=0
		self.speed=self.sp
	end

	x,y=self.speed*math.cos(self.radiomov)*dt,self.speed*math.sin(self.radiomov)*dt

	self.body:setRotation(self.radio,self.body:center())
	self.sensor:setRotation(self.radio,self.body:center())



	if self.immunity then
		self.time=self.time+dt
		if self.time>1 then
			self.time=0
			self.immunity=false
		end
	end

	self.body:move(x,y)
	self.sensor:move(x,y)

	self.ox,self.oy=self.body:center()

	if self.hp<1 then
		score=score+200
		Base.Entities:remove(self)
	end

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
end



function shipia:col(entidad)
	if self.body:collidesWith(entidad.body) and self.id~=entidad.id then
		return true
	end
end

return shipia

--movimiento en onda