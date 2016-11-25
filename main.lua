--=====================--
--== Libraries ========--
--=====================--
push    = require "lib.push"    -- Resolution Handling
screen  = require "lib.shack"   -- Screen effects (shake, rotate, shear, scale)
lem     = require "lib.lem"     -- Events
lue     = require "lib.lue"     -- Hue
state   = require "lib.stager"  -- Scenes and transitions
audio   = require "lib.wave"    -- Audio
trail   = require "lib.trail"   -- Trails
soft    = require "lib.soft"    -- Lerp
ease    = require "lib.easy"    -- Easing
shine   = require "lib.shine"   -- PostProcessing
class   = require "lib.middleclass" -- Classes
bump    = require "lib.bump"    -- Collision
-- anim8   = require "lib.anim8"   -- Anim
Signal  = require "lib.signal"

--==
Colors = require "src.config.Colors"


--== Load Sounds
blockbreak_sound = audio:newSource("assets/sounds/block_break.wav", "static"):setVolume(0.5)
blockhit_sound   = audio:newSource("assets/sounds/block_hit.wav", "static"):setVolume(0.5)
envhit_sound     = audio:newSource("assets/sounds/environment_hit.wav", "static"):setVolume(0.5)
ballOOB_sound    = audio:newSource("assets/sounds/ball_oob.wav", "static"):setVolume(0.5)
--== Screen Dimension Globals
windowW, windowH = love.graphics.getDimensions()


function love.load()
  love.graphics.setBackgroundColor(Colors.darkbrown)
  font = love.graphics.newFont("assets/fonts/slkscr.ttf", 40)
  love.graphics.setFont(font)


  if arg[#arg] == "-debug" then require("mobdebug").start() end -- Debug code for ZeroBrane
  love.window.setMode(1000, 600, {fullscreen=false, vsync=true, resizable=false})
  state:switch("src.states.Game" ,{})
end

function love.update(dt)
  state:update(dt)
end

function love.draw()
  state:draw()
end
