highscore = Gamestate.new()
local atras=nil
local background=nil
local title=nil
local data=nil
function highscore:init()
	background=love.graphics.newImage("assets/background.png")
	atras=love.graphics.newImage("assets/atras.png")
  title=love.graphics.newImage("assets/title2.png")

end

function highscore:enter()
    
    if love.filesystem.getInfo("score.lua") then
      data =love.filesystem.load("score.lua")()
    end
end

function highscore:draw()
	for i = 0, 700 / background:getWidth() do
    	for j = 0, 700 / background:getHeight() do
        	love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
    	end
	end
  love.graphics.draw(title,150,20)

	love.graphics.draw(atras,150,600)

  love.graphics.printf("N°     " .. "Nombre             " .. "Tiempo              " .. "Puntuacion"  ,150,160,600)

  for i, d in ipairs(data) do
    love.graphics.printf(i .. ".         " .. d[3],150,200+(i-1)*40,300)
    love.graphics.printf(string.format("%5.2f",d[1]),300,200+(i-1)*40,200)
    love.graphics.printf(d[2],400,200+(i-1)*40,200)
  end

  if Gamestate.current() == highscore then
    love.graphics.draw(mousei, love.mouse.getX() - mousei:getWidth() / 2, love.mouse.getY() - mousei:getHeight() / 2)
  end

end

function highscore:mousepressed(x,y)
  if x >150 and y >600 and x<150+156 and y<600+62 then
    Gamestate.switch(menu)
  end
end


return highscore