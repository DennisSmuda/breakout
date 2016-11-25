require "src.config.Levels"
require "src.ui.GameOverlay"
require "src.Player"
require "src.Block"
require "src.Ball"
require "src.Wall"
require "src.Block"


blocks = {}

function setupLevel(level)
  for i,row in ipairs(level) do
    for j,blocktype in ipairs(row) do
      if blocktype > 0 then
        local block = Block(100 * j, 50 + 35 * i, blocktype)
        table.insert(blocks, block)
      end
    end
  end
end

local Game = state:new()

gamestate = {
  lives = 3,
  currentLevel = 1,
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
  post_effect = vignette:chain(scanlines):chain(grain)

  --== Setup Game World
  world     = bump.newWorld(20)
  leftWall  = Wall(-1, 0, 1, 600)
  rightWall = Wall(1000, 0, 1, 600)
  topWall   = Wall(0, 0, 1000, 1)
  -- botWall   = Wall(0, 600, 1000, 1) -- For testing

  player = Player()
  ball = Ball()

  setupLevel(levels[gamestate.currentLevel])

  ui = GameOverlay()

end

function Game.update (dt)
  screen:update(dt)
  ball:update(dt)
  player:update(dt)

  if #blocks > 0 then
    updateBlocks()
  else
    win()
  end

end

function win(args)
  ball:reset()
  gamestate.levelComplete = true
  gamestate.waitingToStart = true
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
    player:draw()
    ball:draw()

    for i,block in ipairs(blocks) do
      block:draw()
    end

  end)
    ui:draw(gamestate)
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
