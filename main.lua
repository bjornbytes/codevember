local tick = require 'tick'
local film = true
local thing = '01'

function love.load()
  thing = require(thing)

  love.filesystem.setIdentity(thing.id)
  love.window.setMode(thing.width or 512, thing.height or 512, { msaa = 8 })

  g = love.graphics
  u, v = g.getDimensions()

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
