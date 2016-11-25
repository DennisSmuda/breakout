
Player = class('Player')

function Player:initialize()
  self.type = 'player'
  self.width = 120
  self.height = 20
  self.x = 500 - self.width/2
  self.y = 560
  self.xVel = 0
  self.speed = 25
  self.friction = 2
  world:add(self, self.x, self.y, self.width, self.height)
end


function Player:update(dt)
  self:handleInput(dt)
  self:move(dt)


end


function Player:draw()
  love.graphics.setColor(Colors.white)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end


function Player:move(dt)
  local goalX = self.x + self.xVel
  local actualX, actualY, cols, len = world:move(player, goalX, self.y)
  player.x, player.y = actualX, actualY

  world:update(self, self.x, self.y)

  --== Apply Friction
  self.xVel = self.xVel * (1 - math.min(dt*self.friction, 1))

end



function Player:handleInput(dt)
  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    self.xVel = self.xVel - self.speed*dt
  end

  if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    self.xVel = self.xVel + self.speed*dt
  end
end
