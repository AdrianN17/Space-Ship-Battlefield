menu = Gamestate.new()
local game = require "nivel.game"
local highscore = require "nivel.highscore"
local title=nil
local button={}
local Font=nil
button[1]={}
button[2]={}
local background=nil
local imgb,quadb=nil,nil
local utf8 = require("utf8")
name=""

mousei=nil

function menu:init()
	mousei=love.graphics.newImage("assets/mouse.png")

	background=love.graphics.newImage("assets/background.png")
	title=love.graphics.newImage("assets/title.png")
	button[1][1]=love.graphics.newImage("assets/start.png")
	button[1]["x"],button[1]["y"],button[1]["w"],button[1]["h"]=260,300,button[1][1]:getDimensions()
	

	button[2][1]=love.graphics.newImage("assets/highscore.png")
	button[2]["x"],button[2]["y"],button[2]["w"],button[2]["h"]=225,420,button[2][1]:getDimensions()
	--print(button[1]["x"],button[1]["y"],button[1]["w"],button[1]["h"])

	Font=love.graphics.newFont("assets/kenvector_future.ttf", 12)
	love.graphics.setFont(Font)

	imgb=love.graphics.newImage("assets/buttons.png")

	quadb=love.graphics.newQuad(428,173,190,45,imgb:getDimensions())
end



function menu:draw()
	for i = 0, 700 / background:getWidth() do
    	for j = 0, 700 / background:getHeight() do
        	love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
    	end
	end


	love.graphics.draw(title,40,150)

	love.graphics.draw(button[1][1],260,300)

	love.graphics.draw(button[2][1],225,420)

	love.graphics.print("Mouse: Control de nave",270,520)

	love.graphics.print("Click derecho e izquierdo : ataque y aceleracion",170,550)

	love.graphics.print("P y M : Pausa y volver al menu (si esta en pausa)",180,580)

	love.graphics.print("Esc para salir",10,10)

	love.graphics.print("Version " .. "1.0.0",580,10)

	love.graphics.print("Player : ",480,300)

	love.graphics.draw(imgb,quadb,480,330)

	love.graphics.print(name,485,345,0,1.5,1.5)

	if Gamestate.current() == menu then
		love.graphics.draw(mousei, love.mouse.getX() - mousei:getWidth() / 2, love.mouse.getY() - mousei:getHeight() / 2)
	end
end

function menu:keypressed(key)
	if key=="escape" then
		love.event.push("quit")
	end
end

function menu:mousepressed(x,y)

	if x > button[1]["x"] and y > button[1]["y"] and x<button[1]["x"]+button[1]["w"] and y<button[1]["y"]+button[1]["h"] then
        Gamestate.switch(game)
    end

    if x > button[2]["x"] and y > button[2]["y"] and x<button[2]["x"]+button[2]["w"] and y<button[2]["y"]+button[2]["h"] then
        Gamestate.switch(highscore)
    end

end

function love.textinput(t)
	if string.len(name)<8 and Gamestate.current() == menu then
    	name = name .. t
    end
end

function love.keypressed(key)
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(name, -1)
 
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            name = string.sub(name, 1, byteoffset - 1)
        end
    end
end

return menu