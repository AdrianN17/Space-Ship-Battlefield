Gamestate = require "libs.gamestate"

local menu = require "nivel.menu"
local serialize = require 'libs.ser'
function love.load()
	love.mouse.setVisible(false)
	data()
	Gamestate.registerEvents()
  	Gamestate.switch(menu)

end

function data()
	if not love.filesystem.getInfo("score.lua") then
		t={}
		table.insert(t,{500,100000,"Max"})
		table.insert(t,{205,75000,"Pedro"})
		table.insert(t,{155,55000,"Maria"})
		table.insert(t,{125,35000,"Frank"})
		table.insert(t,{105,30000,"Albert"})
		table.insert(t,{85,25000,"Carlos"})
		table.insert(t,{65,20000,"Lisa"})
		table.insert(t,{45,15000,"Juan"})
		table.insert(t,{25,10000,"John"})
		love.filesystem.write("score.lua",serialize(t))
	end
end


--Arreglar sonido