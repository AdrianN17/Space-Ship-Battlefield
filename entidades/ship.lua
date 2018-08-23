local Class = require "libs.class"
local rocket = require "entidades.rocket"
local Base = require "nivel.Base"
local HC = require "libs.HC"
local Entity= require "entidades.Entity"
local ship = Class{
	__includes = Entity
}

function ship:init(x,y)
	self.type="ship"
	self.id="player"
	self.x,self.y=x,y
	self.w,self.h=101,74

	self.typebullet=1

	self.speed=450
	
	self.img,self.img2=imgs["partes"],imgs["anima"]
	self.quad,self.quad2=quads["ship"],quads["anima"]

	self.body=HC.rectangle(self.x,self.y,self.w,self.h)
	self.radio=0
	self.radiomov=0
	self.mx,self.my=0,0

	self.hp=20

	self.immunity=false
	self.time=0
	self.time2=0
	self.aceleracion=false

	self.fuel=20

	self.timescore=0

	self.ox,self.oy=self.body:center()

	self.visible=true

	self.disparo=false

	self.timed=1.6

	self.val=false
end

function ship:draw()

	
	if self.visible then
		love.graphics.draw(self.img,self.quad[4],self.ox,self.oy,self.radio,1,-1,35.5,10)
		love.graphics.draw(self.img,self.quad[4],self.ox,self.oy,self.radio,1,-1,-4.5,10)

		love.graphics.draw(self.img,self.quad[1],self.ox, self.oy,self.radio,-1,1,-9.5,34)
		love.graphics.draw(self.img,self.quad[1],self.ox, self.oy,self.radio,1,1,-9.5,34)

		love.graphics.draw(self.img,self.quad[2],self.ox, self.oy,self.radio,1,1,22.5,35.5)

		love.graphics.draw(self.img,self.quad[3],self.ox, self.oy,self.radio,1,1,8,0)

		love.graphics.draw(self.img2,self.quad2[1],self.ox,self.oy,self.radio,1,-1,-13.5,-36)
		love.graphics.draw(self.img2,self.quad2[1],self.ox,self.oy,self.radio,1,-1,27.5,-36)
	end

	if self.speed>600 then
		love.graphics.draw(self.img2,self.quad2[2],self.ox,self.oy,self.radio,12,2,13/2,0)
	end
	--self.body:draw("line")

end

function ship:update(dt)
	self.timescore=self.timescore+dt

	local x,y=self.speed*math.cos(self.radiomov)*dt,self.speed*math.sin(self.radiomov)*dt
	
	self.body:move(x,y)

	self.mx,self.my= cam:toWorld(love.mouse.getPosition())
	self.radiomov=math.atan2(self.my-self.oy,self.mx-self.ox)
	self.radio=math.rad(-90)+self.radiomov

	self.body:setRotation(self.radio)

	self.x=self.x+x
	self.y=self.y+y

	self.ox,self.oy=self.body:center()

	for i, lista in ipairs(Base.Entities.entityList) do

		if lista:col(self) and not self.immunity and lista.type~="astronauta" then
			
			if lista.type~="laser" or lista.type~="rocket" then
				self.hp=self.hp-1
			end

			self.immunity=true
		end

		--atropellar
		if lista:col(self) and lista.type=="astronauta"  then
			lista.hp=lista.hp-1
		end
	end

	if self.aceleracion then
		self.fuel=self.fuel-dt

		if self.fuel>0 then
			if self.speed<1000 then
				self.speed=self.speed+100*dt

			else
				self.speed=1000
			end
		else
			self.aceleracion=false
			self.fuel=0
		end

	else
		if self.speed>450 then
			self.speed=self.speed-dt*150
		else
			self.speed=450
		end
		

		if self.fuel<20 then
			self.fuel=self.fuel+dt/10
		end
	end

	if self.immunity then
		self.time=self.time+dt
		self.time2=self.time2+dt

		if self.time2>0.075 then
			self.time2=0
			self.visible= not self.visible
		end

		if self.time>1.5 then
			self.time=0
			self.immunity=false
			self.visible=true
		end
	end

	if self.hp<1 then
		Base.Entities:remove(self)
	end

	if score>5000 then
		self.typebullet=2
	end
	if score>50000 then
		self.typebullet=3
	end

	


	if self.disparo then
		self.timed=self.timed+dt/self.typebullet

		local v=0
		if self.typebullet==1 then
			v=2000
		elseif self.typebullet==2 then
			v=1500
		elseif self.typebullet==3 then
			v=1000
		end

		if self.timed>0.15 then
			sound[3]:play()
			if self.typebullet>0 then
				Base.Entities:add(rocket(self.ox-12/2,self.oy-25/2,self.radio,self.radiomov+math.rad(2.5),v,self.id,self.typebullet))
				Base.Entities:add(rocket(self.ox-12/2,self.oy-25/2,self.radio,self.radiomov,v,self.id,self.typebullet))
				Base.Entities:add(rocket(self.ox-12/2,self.oy-25/2,self.radio,self.radiomov-math.rad(2.5),v,self.id,self.typebullet))
			end

			if self.typebullet>2 then
				Base.Entities:add(rocket(self.ox-12/2,self.oy-25/2,self.radio,self.radiomov-math.rad(7.5),v,self.id,self.typebullet))
				Base.Entities:add(rocket(self.ox-12/2,self.oy-25/2,self.radio,self.radiomov+math.rad(7.5),v,self.id,self.typebullet))
			end

			self.timed=0
		end
	end

end

function ship:mousepressed(x, y, button)
	
	if button ==1 then
		self.disparo=true
	end	
	if button ==2 then
		self.aceleracion=true
	end	
end

function ship:col(entidad)
	if self.body:collidesWith(entidad.body) and self.id~=entidad.id then
		return true
	end
end



function ship:mousereleased(x, y, button)
	if button==1 then

		self.disparo=false
		self.timed=1.6
	end

	if button ==2 then
		self.aceleracion=false

	end
end

function ship:keypressed(key)
	if key=="a" then
		self.hp=0
	end
end





return ship