require "src.config.Levels"
require "src.ui.GameOverlay"
require "src.ui.GameBackdrop"
require "src.Player"
require "src.Block"
require "src.Ball"
require "src.Wall"
require "src.Block"
require "src.LevelManager"


local Game = state:new()

--== Globals
blocks = {}
gamestate = {
  lives = 3,
  currentLevel = 6,
  points = 0,
  waitingToStart = true
}


function Game.load (args)
  --== PostProcessing
  local grain     = shine.filmgrain()
  local scanlines = shine.scanlines()
  scanlines.parameters = {pixel_size = 3, opacity = 0.2 }
  local vignette  = shine.vignette()
  vignette.parameters = {radius = 0.7, opacity = 0.2}
  post_effect = scanlines:chain(grain):chain(vignette)


  --== Setup Game World
  world     = bump.newWorld(20)
  leftWall  = Wall(-1, 0, 1, 600)
  rightWall = Wall(1000, 0, 1, 600)
  topWall   = Wall(0, 0, 1000, 1)
  -- botWall   = Wall(0, 600, 1000, 1) -- For testing
  player = Player()
  ball = Ball()

  levelManager = LevelManager()
  levelManager:setupLevel()

  --== Camera
  screenW, screenH = love.graphics.getDimensions()
  camera = Camera(player.x, player.y - 300)

  local dx, dy = screenW - camera.x, screenH - camera.y
  camera:lookAt(screenW/2, screenH/2)


  ui = GameOverlay()
  bg = GameBackdrop()
end


function Game.update (dt)
  levelManager:update(dt)
  bg:update(dt)

  screen:update(dt)
  ball:update(dt)
  player:update(dt)
  ui:update(dt)

  if #blocks > 0 then
    updateBlocks()
  else
    win()
  end
end


function win(args)
  gamestate.currentLevel = gamestate.currentLevel+1
  if gamestate.currentLevel > #levels then
    -- Win Game
    state:switch("src.states.Highscore")
    return
  end

  ball:reset()
  gamestate.levelComplete = true
  gamestate.waitingToStart = true
  levelManager:newLevel()
end


function updateBlocks()
  for i,block in ipairs(blocks) do
    if block.health <= 0 then
      block:die()
      table.remove(blocks, i)
    end
  end
end


function Game.draw()
  screen:apply()

  post_effect:draw(function()

    camera:attach()

      bg:draw()
      player:draw()
      ball:draw()

      for i,block in ipairs(blocks) do
        block:draw()
      end

    camera:detach()

    ui:draw(gamestate)

  end)

end


function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then state:switch("src.states.Menu") end

  if key == "space" then
    if gamestate.waitingToStart then
      ball:start()
      gamestate.waitingToStart = false
    end
  end

end

return Game
