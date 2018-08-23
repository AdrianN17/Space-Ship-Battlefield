pause = Gamestate.new()
local img=nil
local img2,quad=nil,nil
function pause:init()
	img=love.graphics.newImage("assets/pause.png")
  img2=love.graphics.newImage("assets/buttons.png")
  quad=love.graphics.newQuad(400,734,38,36,img2:getDimensions())
end

function pause:enter(from)
  self.from = from -- record previous state
end

function pause:draw()

  self.from:draw()
  --pausar
  love.graphics.draw(img,220,200)
  love.graphics.print("Presione la x para volver al menu",200,330)

  love.graphics.draw(img2,quad,650,10)

  if Gamestate.current() == pause then
    love.graphics.draw(mousei, love.mouse.getX() - mousei:getWidth() / 2, love.mouse.getY() - mousei:getHeight() / 2)
  end

end

function pause:keypressed(key)
  if key == 'p' then
    return Gamestate.pop() -- return to previous state
  end

  
  	
end

function pause:mousepressed(x,y,button)
    if x > 650 and y > 10 and x<650+38 and y<10+36 then
      self.from:reset()
      Gamestate.switch(menu)
    end
end

return pause
