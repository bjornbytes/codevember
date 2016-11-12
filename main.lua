tick = require 'tick'
t = 0
local film = true
local id = '08'

function love.load()
  thing = require(id)

  love.filesystem.setIdentity('codevember' .. id)
  love.window.setMode(thing.width or 512, thing.height or 512, { msaa = 8, highdpi = true })

  g = love.graphics
  u, v = g.getDimensions()

  tick.rate = 1 / (thing.rate or 50)

  thing.load()
end

function love.update(dt)
  t = (t or 0) + dt
  thing.update(dt)
end

function love.draw()
  thing.draw()

  local frame, start, stop = tick.frame, thing.start, thing.stop
  if film and start and stop and frame >= start and frame < stop then
    local screenshot = g.newScreenshot()
    screenshot:encode('png', string.format('%03d.png', tick.frame - thing.start))
  end
end
