
GameOverlay = class('GameOverlay')

function GameOverlay:initialize()

end

function GameOverlay:draw()
  love.graphics.setColor(Colors.white)
  love.graphics.print('Points: ' .. gamestate.points, 10, 10)
  love.graphics.printf('Level: ' .. gamestate.currentLevel, 0, 10, 1000-10, 'right')
  love.graphics.printf('Lives: ' .. gamestate.lives, 0, 10, 1000, 'center')

  if gamestate.waitingToStart then
    love.graphics.printf('Space to Start', 0, windowH/2, 1000, 'center')
  end
end
