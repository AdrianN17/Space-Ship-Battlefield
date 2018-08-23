local Gamestate = require 'libs.gamestate'

local serialize = require 'libs.ser'
local HC = require "libs.HC"
local Base = require "nivel.Base"
local ship = require "entidades.ship"
local Class = require "libs.class"
local gamera = require "libs.gamera"
local pause = require "nivel.pause"
local background=nil
cam=nil
local cam2=nil
local s=nil

local Font = nil
local cursor=nil
local enemy={}

enemy[1] = require "entidades.turret"
enemy[2] = require "entidades.meteor"
enemy[3] = require "entidades.satelite"
enemy[4] = require "entidades.station"
enemy[5] = require "entidades.central"
enemy[6] = require "entidades.base"

enemy[7] = require "entidades.cohete"
enemy[8] = require "entidades.cohete2"
enemy[9]= require "entidades.cohete3"
enemy[10]= require "entidades.cohete4"

enemy[11] = require "entidades.shipia"

sound={}

local img={}
local quad={}


imgs={}
quads={}

score=0

local game = Class{
	__includes = Base
}

function game:init()
	background=love.graphics.newImage("assets/background.png")
	Base.init(self)
	cam=gamera.new(0,0,10000,10000)
	cam:setScale (0.5)
	cam:setWindow(0,0,700,450)

	cam2=gamera.new(0,0,10000,10000)
	cam2:setWindow(470,460,220,230)
	cam2:setScale(0.1)

	Font=love.graphics.newFont("assets/kenvector_future.ttf", 12)
	love.graphics.setFont(Font)

	love.mouse.setVisible(false)

	self:multi()

	cursor = love.graphics.newImage("assets/cursor.png")

end

function game:enter()
	if name=="" then
		name="player"
	end
	s = ship(100,100)
	Base.Entities:actor(s)
	self:insert()
end

function game:update(dt)
	cam:setPosition(s.x,s.y)
	cam2:setPosition(s.x,s.y)
	Base.Entities:update(dt)
	--collectgarbage()
end

function game:draw()
	

	cam:draw(function(l,t,w,h)
		for i = 0, 10000 / background:getWidth() do
        	for j = 0, 10000 / background:getHeight() do
            	love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        	end
    	end
		Base.Entities:draw()
	end)

	love.graphics.draw(img[1],quad[1],460,450,0,2.4,2.5)

	cam2:draw(function(l,t,w,h)
		Base.Entities:draw()
	end)
	--[[
		love.graphics.print(s.hp,0,0)
		love.graphics.print(s.fuel,0,50)
		love.graphics.print(s.speed,0,100)
		love.graphics.print(tostring(s.immunity),0,150)
	]]
	--vida
	love.graphics.print("Vida" , 50,590)

	if s.hp>=1 then
		love.graphics.draw(img[1],quad[2][1][1],50,620)
	end

	for i=0,18,1 do
		if s.hp>=i+1 then
			love.graphics.draw(img[1],quad[2][1][2],56+i*16,620)
		end
	end

	if s.hp>=20 then
		love.graphics.draw(img[1],quad[2][1][3],56+19*16,620)
	end
	--combustible
	love.graphics.print("combustible" , 50,520)

	if math.floor(s.fuel)>=0.5 then
		love.graphics.draw(img[1],quad[2][2][1],50,550)
	end

		for i=0,18,1 do
			if math.floor(s.fuel)>=i+1 then
				love.graphics.draw(img[1],quad[2][2][2],56+i*16,550)
			end
		end

	if math.floor(s.fuel)>=20 then
		love.graphics.draw(img[1],quad[2][2][3],56+19*16,550)
	end

	--timescore
	love.graphics.print("Tiempo: ",280,480)
	love.graphics.print(string.format("%.2f", s.timescore),380,480)
	
	--score
	love.graphics.print("Score: ",280,510)
	love.graphics.print(score,380,510)

	--muerto

	
	if s.hp<0.1 then
		love.graphics.print("Presione enter para reiniciar",250,250)
	end

	local stats = love.graphics.getStats()
 
    local str = string.format("Estimated amount of texture memory used: %.2f MB", stats.texturememory / 1024 / 1024)
    love.graphics.print(str, 10, 50)

	love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count')/1000, 10,10)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 500, 10)

	--cursor
	if Gamestate.current() == game then
		love.graphics.draw(cursor, love.mouse.getX() - cursor:getWidth() / 2, love.mouse.getY() - cursor:getHeight() / 2)
	end
end

function game:mousepressed(x,y,button)
	Base.Entities:mousepressed(x,y,button)
end

function game:mousereleased(x,y,button)
	Base.Entities:mousereleased(x,y,button)
end
function game:keypressed(key,isrepeat)
  Base.Entities:keypressed(key)

  if key=="return" and s.hp<0.1 then
  	self:save(s.timescore,score,name)
  	self:reset()
  	Gamestate.switch(self)	
  end

  if key=="p" and s.hp>0.1 then
  	Gamestate.push(pause)
  end
end



function game:insert()
	local Enemies={}
	Base.Entities:add(enemy[7](100,100,0))


	for i=1,love.math.random(3,6),1 do
		local x,y = love.math.random(600,9700), love.math.random(600,9700)
		Base.Entities:add(enemy[4](x,y))
	end

	for i=1,love.math.random(3,6),1 do
		local x,y = love.math.random(600,9700), love.math.random(600,9700)
		Base.Entities:add(enemy[5](x,y))
	end

	for i=1,love.math.random(3,6),1 do
		local x,y = love.math.random(600,9700), love.math.random(600,9700)
		Base.Entities:add(enemy[6](x,y))
	end

	for i=1,love.math.random(25,30),1 do 
		local x,y = love.math.random(600,9700), love.math.random(600,9700)
		local c=love.math.random(7,10)
		local r=love.math.random(0,360)
		Base.Entities:add(enemy[c](x,y,r))
	end

	for i=1,love.math.random(20,30),1 do
		local x,y = love.math.random(600,9700), love.math.random(600,9700)
		Base.Entities:add(enemy[3](x,y))
	end 

	for i=1,love.math.random(25,40),1 do
		local x,y = love.math.random(600,9700), love.math.random(600,9700)
		Base.Entities:add(enemy[1](x,y))
	end

	for i=1,love.math.random(3,6),1 do
		local x,y = love.math.random(600,9700), love.math.random(600,9700)
		Base.Entities:add(enemy[2](x,y,1,180))
	end

	for i=1, love.math.random(40,55),1 do
		local x,y = love.math.random(600,9700), love.math.random(600,9700)
		local r=love.math.random(0,360)
		Base.Entities:add(enemy[11](x,y,r))
	end
end

function game:reset()
	Base.Entities:clear()
	score=0
	collectgarbage('collect')
	HC.resetHash()
end

function game:save(t,c,name)
	if love.filesystem.getInfo("score.lua") then
		local dataold=love.filesystem.load("score.lua")()

		local validate=false

		if dataold[9][2]<c then
			validate=true
		end

		if validate then
			table.insert(dataold,{t,c,name})
			table.sort(dataold, function(a,b) return a[2] > b[2] end)
			if dataold[10]~=nil then
				table.remove(dataold,10)
			end
			love.filesystem.write("score.lua",serialize(dataold))
		end
	end
end

function game:multi()
	imgs["astronauta"]=love.graphics.newImage("assets/astronauta.png")

	quads["astronauta"]={}
	quads["astronauta"][1]=love.graphics.newQuad(194, 98,34 ,44 , imgs["astronauta"]:getDimensions())
	quads["astronauta"][2]=love.graphics.newQuad(152, 98,37 ,44 , imgs["astronauta"]:getDimensions())
	quads["astronauta"][3]=love.graphics.newQuad(0, 49,50 ,44 , imgs["astronauta"]:getDimensions())

	imgs["torres"]=love.graphics.newImage("assets/torres.png")

	quads["base"]={}
	quads["base"][1]=love.graphics.newQuad(214,352,124,58, imgs["torres"]:getDimensions())
	quads["base"][2]=love.graphics.newQuad(530,454,84,36, imgs["torres"]:getDimensions())
	quads["base"][3]=love.graphics.newQuad(308,464,40,28, imgs["torres"]:getDimensions())
	quads["base"][4]=love.graphics.newQuad(316,415,32,44, imgs["torres"]:getDimensions())
	quads["base"][5]=love.graphics.newQuad(501,405,122,44, imgs["torres"]:getDimensions())
	quads["base"][6]=love.graphics.newQuad(177,0,16,66, imgs["torres"]:getDimensions())

	quads["central"]={}
	quads["central"][1]=love.graphics.newQuad(177,167,42,44, imgs["torres"]:getDimensions())
	quads["central"][2]=love.graphics.newQuad(177,396,24,44, imgs["torres"]:getDimensions())
	quads["central"][3]=love.graphics.newQuad(206,415,40,28, imgs["torres"]:getDimensions())
	quads["central"][4]=love.graphics.newQuad(316,415,32,44, imgs["torres"]:getDimensions())
	quads["central"][5]=love.graphics.newQuad(0,0,40,40, imgs["torres"]:getDimensions())
	quads["central"][6]=love.graphics.newQuad(177,347,32,44, imgs["torres"]:getDimensions())
	quads["central"][7]=love.graphics.newQuad(177,314,40,28, imgs["torres"]:getDimensions())
	quads["central"][8]=love.graphics.newQuad(177,118,42,44, imgs["torres"]:getDimensions())
	quads["central"][9]=love.graphics.newQuad(198,448,48,44, imgs["torres"]:getDimensions())
	quads["central"][10]=love.graphics.newQuad(251,458,52,34, imgs["torres"]:getDimensions())
	quads["central"][11]=love.graphics.newQuad(177,265,32,44, imgs["torres"]:getDimensions())
	quads["central"][12]=love.graphics.newQuad(308,464,40,28, imgs["torres"]:getDimensions())
	quads["central"][13]=love.graphics.newQuad(440,405,56,44, imgs["torres"]:getDimensions())
	quads["central"][14]=love.graphics.newQuad(177,265,32,44, imgs["torres"]:getDimensions())
	quads["central"][15]=love.graphics.newQuad(501,405,122,44, imgs["torres"]:getDimensions())

	imgs["laser"]=love.graphics.newImage("assets/laser_anima.png")

	quads["laser"]={}

	quads["laser"][1]=love.graphics.newQuad(135,361,37,37,imgs["laser"]:getDimensions())--circular

	quads["laser"][2]=love.graphics.newQuad(175,491,13,54,imgs["laser"]:getDimensions())--lineal

	imgs["objeto"]=love.graphics.newImage("assets/objetos.png")

	imgs["cohete"]=love.graphics.newImage("assets/partes2.png")

	quads["cohete1"]={}

	quads["cohete1"][1]=love.graphics.newQuad(190,138,68, 73, imgs["cohete"]:getDimensions())
	quads["cohete1"][2]=love.graphics.newQuad(190,69,68,64, imgs["cohete"]:getDimensions())
	quads["cohete1"][3]=love.graphics.newQuad(117,0,68,64, imgs["cohete"]:getDimensions())
	quads["cohete1"][4]=love.graphics.newQuad(190,0,68,64, imgs["cohete"]:getDimensions())
	quads["cohete1"][5]=love.graphics.newQuad(107,152,68,41, imgs["cohete"]:getDimensions())
	quads["cohete1"][6]=love.graphics.newQuad(320,261,37,89, imgs["cohete"]:getDimensions())

	quads["cohete2"]={}
	quads["cohete2"][1]=love.graphics.newQuad(336,0,68,78, imgs["cohete"]:getDimensions())
	quads["cohete2"][2]=love.graphics.newQuad(44,78,68,64, imgs["cohete"]:getDimensions())
	quads["cohete2"][3]=love.graphics.newQuad(190,69,68,64, imgs["cohete"]:getDimensions())
	quads["cohete2"][4]=love.graphics.newQuad(107,286,68,64, imgs["cohete"]:getDimensions())
	quads["cohete2"][5]=love.graphics.newQuad(0,310,68,40, imgs["cohete"]:getDimensions())
	quads["cohete2"][6]=love.graphics.newQuad(73,147,29,170, imgs["cohete"]:getDimensions())

	quads["cohete3"]={}
	quads["cohete3"][1]=love.graphics.newQuad(0,227,68,78, imgs["cohete"]:getDimensions())
	quads["cohete3"][2]=love.graphics.newQuad(190,0,68,64, imgs["cohete"]:getDimensions())
	quads["cohete3"][3]=love.graphics.newQuad(44,78,68,64, imgs["cohete"]:getDimensions())
	quads["cohete3"][4]=love.graphics.newQuad(190,69,68,64, imgs["cohete"]:getDimensions())
	quads["cohete3"][5]=love.graphics.newQuad(0,310,68,40, imgs["cohete"]:getDimensions())
	quads["cohete3"][6]=love.graphics.newQuad(268,209,47,85, imgs["cohete"]:getDimensions())
	quads["cohete3"][7]=love.graphics.newQuad(51, 62, 42,42, imgs["objeto"]:getDimensions())
	quads["cohete3"][8]=love.graphics.newQuad(98, 62, 17,38, imgs["objeto"]:getDimensions())


	quads["cohete4"]={}
	quads["cohete4"][1]=love.graphics.newQuad(336,0,68,78, imgs["cohete"]:getDimensions())
	quads["cohete4"][2]=love.graphics.newQuad(44,78,68,64, imgs["cohete"]:getDimensions())
	quads["cohete4"][3]=love.graphics.newQuad(107,286,68,64, imgs["cohete"]:getDimensions())
	quads["cohete4"][4]=love.graphics.newQuad(190,0,68,64, imgs["cohete"]:getDimensions())
	quads["cohete4"][5]=love.graphics.newQuad(189,247,74,45, imgs["cohete"]:getDimensions())
	quads["cohete4"][6]=love.graphics.newQuad(370,83,36,160, imgs["cohete"]:getDimensions())
	quads["cohete4"][7]=love.graphics.newQuad(51, 62, 42,42, imgs["objeto"]:getDimensions())
	quads["cohete4"][8]=love.graphics.newQuad(170, 0, 26,41, imgs["objeto"]:getDimensions())
	quads["cohete4"][9]=love.graphics.newQuad(167, 93, 27,41, imgs["objeto"]:getDimensions())


	imgs["meteoro"]=love.graphics.newImage("assets/meteoro.png")

	quads["meteoro"]=love.graphics.newQuad( 0, 0, 214,227, imgs["meteoro"]:getDimensions())
	
	

	quads["satelite"]=love.graphics.newQuad(164, 294,168,40, imgs["objeto"]:getDimensions())

	quads["station"]={}
	quads["station"][1]=love.graphics.newQuad(251,415,60,38,imgs["torres"]:getDimensions())
	quads["station"][2]=love.graphics.newQuad(440,405,56,44,imgs["torres"]:getDimensions())
	quads["station"][3]=love.graphics.newQuad(0,45,172,52,imgs["torres"]:getDimensions())
	quads["station"][4]=love.graphics.newQuad(177,347,32,44,imgs["torres"]:getDimensions())
	quads["station"][5]=love.graphics.newQuad(530,454,84,36,imgs["torres"]:getDimensions())
	quads["station"][6]=love.graphics.newQuad(353,405,82,42,imgs["torres"]:getDimensions())
	quads["station"][7]=love.graphics.newQuad(86,379,48,46,imgs["laser"]:getDimensions())
	quads["station"][8]=love.graphics.newQuad(0,330,9,57,imgs["laser"]:getDimensions())

	quads["turret"]={}
	quads["turret"][1]=love.graphics.newQuad(51, 62, 42,42, imgs["objeto"]:getDimensions())
	quads["turret"][2]=love.graphics.newQuad( 98, 62, 17,38, imgs["objeto"]:getDimensions())

	imgs["partes"]=love.graphics.newImage("assets/partes.png")
	quads["shipia"]={}
	quads["shipia"][1]=love.graphics.newQuad(0,646,45,66, imgs["partes"]:getDimensions())
	quads["shipia"][2]=love.graphics.newQuad(0,0,45,77, imgs["partes"]:getDimensions())
	quads["shipia"][3]=love.graphics.newQuad(0,717,43,62, imgs["partes"]:getDimensions())
	quads["shipia"][4]=love.graphics.newQuad(194,727,24,29, imgs["partes"]:getDimensions())

	imgs["rocket"]=love.graphics.newImage("assets/arma.png")

	quads["rocket"]={}


	quads["rocket"][1]=love.graphics.newQuad(80, 51, 16,22, imgs["rocket"]:getDimensions())
	quads["rocket"][2]=love.graphics.newQuad(81,264,20,35, imgs["rocket"]:getDimensions())

	quads["rocket"][3]=love.graphics.newQuad(64,0,22,46, imgs["rocket"]:getDimensions())


	quads["rocket"][4]=love.graphics.newQuad(42, 43, 12,25, imgs["rocket"]:getDimensions())

	imgs["anima"]=love.graphics.newImage("assets/animacion.png")

	quads["ship"]={}
	quads["ship"][1]=love.graphics.newQuad( 136, 577,41,71, imgs["partes"]:getDimensions())
	quads["ship"][2]=love.graphics.newQuad( 169, 0, 45,66, imgs["partes"]:getDimensions())
	quads["ship"][3]=love.graphics.newQuad( 181, 209, 16,16, imgs["partes"]:getDimensions())
	quads["ship"][4]=love.graphics.newQuad( 233, 744, 29,47, imgs["partes"]:getDimensions())

	quads["anima"]={}--del ship
	quads["anima"][1]=love.graphics.newQuad(68,71,12,126,imgs["anima"]:getDimensions())
	quads["anima"][2]=love.graphics.newQuad(48,0,13,30,imgs["anima"]:getDimensions())

	quads["anima2"]={}
	quads["anima2"][1]=love.graphics.newQuad(0,168,14,23,imgs["anima"]:getDimensions())
	quads["anima2"][2]=love.graphics.newQuad(66,41,14,25,imgs["anima"]:getDimensions())

	--ui
	img[1]=love.graphics.newImage("assets/ui.png")

	quad[1]=love.graphics.newQuad(0,0,100,100, img[1]:getDimensions())

	quad[2]={}
	quad[2][1]={}
	quad[2][2]={}
	quad[2][3]={}
	quad[2][4]={}
	quad[2][5]={}

	quad[2][1][1]=love.graphics.newQuad(350 ,52 ,6 ,26 ,img[1]:getDimensions())
	quad[2][1][2]=love.graphics.newQuad(256 ,68 ,16 ,26 ,img[1]:getDimensions())
	quad[2][1][3]=love.graphics.newQuad(366 ,52 ,6 ,26 ,img[1]:getDimensions())
	quad[2][1][4]=love.graphics.newQuad(440 ,289 ,19 ,26 ,img[1]:getDimensions())
	
	quad[2][2][1]=love.graphics.newQuad(290,0,6,26,img[1]:getDimensions())
	quad[2][2][2]=love.graphics.newQuad(290,40,16,26,img[1]:getDimensions())
	quad[2][2][3]=love.graphics.newQuad(424,0,6,26,img[1]:getDimensions())
	quad[2][2][4]=love.graphics.newQuad(346,16,19,26,img[1]:getDimensions())

	quad[2][3][1]=love.graphics.newQuad(424,36,6,26,img[1]:getDimensions())
	quad[2][3][2]=love.graphics.newQuad(316,40,16,26,img[1]:getDimensions())
	quad[2][3][3]=love.graphics.newQuad(220,42,6,26,img[1]:getDimensions())
	quad[2][3][4]=love.graphics.newQuad(440,90,19,26,img[1]:getDimensions())

	quad[2][4][1]=love.graphics.newQuad(505,332,6,26,img[1]:getDimensions())
	quad[2][4][2]=love.graphics.newQuad(474,400,16,26,img[1]:getDimensions())
	quad[2][4][3]=love.graphics.newQuad(506,368,6,26,img[1]:getDimensions())
	quad[2][4][4]=love.graphics.newQuad(522,358,19,26,img[1]:getDimensions())

	quad[2][5][1]=love.graphics.newQuad(476,132,6,26,img[1]:getDimensions())
	quad[2][5][2]=love.graphics.newQuad(607,368,16,26,img[1]:getDimensions())
	quad[2][5][3]=love.graphics.newQuad(440,152,6,26,img[1]:getDimensions())
	quad[2][5][4]=love.graphics.newQuad(476,332,19,26,img[1]:getDimensions())

	sound[1]=love.audio.newSource("assets/s_laser.wav","static")
	sound[2]=love.audio.newSource("assets/s_lasercircle.wav","static")
	sound[3]=love.audio.newSource("assets/s_rocket.wav","static")






end


return game
