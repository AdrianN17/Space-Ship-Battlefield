local HC = require "libs.HC"
local Gamestate = require "libs.gamestate"
local Class = require "libs.class"
local Entities = require "entidades.Entities"

local Base = Class {
	__includes = Gamestate,
	init = function(self)
	Entities:enter()
	end;
	Entities = Entities;
}

function Base:keypressed(key)
	--[[if Gamestate.current() ~= pause and key == 'p' then
    	Gamestate.push(pause)
  	end]]
end


return Base