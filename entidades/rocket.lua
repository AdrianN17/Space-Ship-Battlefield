local Class = require "libs.class"
local HC = require "libs.HC"
local Base = require "nivel.Base"
local Entity= require "entidades.Entity"
local rocket = Class{
	__includes = Entity
}

function rocket:init(x,y,r,rm,speed,id,daño)

	if daño==nil then
		self.daño=1
	else
		self.daño=daño
	end

	self.type="rocket"
	self.id=id
	self.x,self.y=x,y
	self.speed=speed
	
	self.img,self.img2=imgs["rocket"],imgs["anima"]

	self.quad={}
	self.data={}

	
	if self.id=="player" then
		self.quad[1]=quads["rocket"][1]
		self.quad[2]=quads["rocket"][2]
		self.quad[3]=quads["rocket"][3]
		self.anima2=quads["anima2"][1]

		self.data={{16,22},{20,35},{22,46}}
		
	else
		self.quad[1]=quads["rocket"][4]
		self.anima2=quads["anima2"][2]
		self.data={{12,25}}
		
	end
	--
	

	self.anima=quads["anima"][1]
	


	
	self.body=HC.rectangle(self.x,self.y,self.data[self.daño][1],self.data[self.daño][2])
	self.r,self.rm=r,rm
	self.time=0
	self.hp=1
	self.ox,self.oy=self.body:center()
end

function rocket:draw()
	love.graphics.draw(self.img,self.quad[self.daño],self.ox,self.oy,self.r,-1,-1,self.data[self.daño][1]/2,self.data[self.daño][2]/2)
	--self.body:draw("line")
	--6 es de anima
	love.graphics.draw(self.img2,self.anima,self.ox,self.oy,self.r,1,-1,6,-self.data[self.daño][2]/2)
	love.graphics.draw(self.img2,self.anima2,self.ox,self.oy,self.r,1,1,6,(-self.data[self.daño][2]/2)+10)
end

function rocket:update(dt)
	local x,y=self.speed*math.cos(self.rm)*dt,self.speed*math.sin(self.rm)*dt
	self.time=self.time+dt
	
	self.body:move(x,y)
	self.body:setRotation(self.r)
	self.ox,self.oy=self.body:center()

	for i, lista in ipairs(Base.Entities.entityList) do

		local a,b = lista:col(self)
		if a  then

			if b == nil and (lista.immunity==false or lista.immunity==nil) then
				if lista.type~="laser" then
					lista.hp=lista.hp-self.daño
				end
			end
			if lista.type=="ship" then
				lista.immunity=true
			end

			self.hp=self.hp-1

			a,b=nil
			collectgarbage()
			break


		end

	end


	if self.time>1.5 or self.hp<1 then
		Base.Entities:remove(self)
	end

	if self.ox<-200 or self.oy<-200 or self.ox>10250 or self.oy>10200 then
		Base.Entities:remove(self)
	end
end

function rocket:col(entidad)
	if self.body:collidesWith(entidad.body) and self.id~=entidad.id then
		return true
	end

end


return rocket