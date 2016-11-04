local thing = {}
thing.id = 'codevember01'
thing.rate = 50
thing.start = 250
thing.stop = 450

local function lerp(x, y, z)
  return x + (y - x) * z
end

local function makeShape(sides, angle)
  local res = {}
  local size = 100
  res.sides = sides
  res.size = size

  local angle = -math.pi / 2 + angle
  for i = 1, sides do
    table.insert(res, u / 2 + size * math.cos(angle))
    table.insert(res, v / 2 + size * math.sin(angle))
    angle = angle + (2 * math.pi / sides)
  end

  return res
end

local function interpolateShape(shape, z)
  local sides = shape.sides
  local index = (z * sides)
  local from = 1 + math.floor(index) % (sides)
  local to = 1 + math.ceil(index) % (sides)
  local factor = index - math.floor(index)
  local x = lerp(shape[2 * from - 1], shape[2 * to - 1], factor)
  local y = lerp(shape[2 * from - 0], shape[2 * to - 0], factor)
  return x, y
end

function thing.load()
  thing.color = { 128, 0, 255 }
  thing.background = { 50, 50, 50 }
  thing.shapes = {
    makeShape(3, 0),
    makeShape(4, math.pi / 2),
    makeShape(5, math.pi),
    makeShape(6, 3 * math.pi / 2)
  }

  thing.lerpd = {}
  for i = 1, 360 do
    local x, y = interpolateShape(thing.shapes[1], i / 360)
    table.insert(thing.lerpd, u / 2)
    table.insert(thing.lerpd, v / 2)
  end
end

function thing.update(dt)
  local target = thing.shapes[1 + math.floor(t) % #thing.shapes]
  local smooth = 2 ^ (10 * ((t - math.floor(t)) - 1))
  for i = 1, 360 do
    local x, y = interpolateShape(target, i / 360)
    thing.lerpd[2 * i - 1] = lerp(thing.lerpd[2 * i - 1], x, smooth)
    thing.lerpd[2 * i - 0] = lerp(thing.lerpd[2 * i - 0], y, smooth)
  end
end

function thing.draw()
  g.clear(thing.background)
  g.setColor(thing.color)
  g.translate(u / 2, v / 2)
  g.rotate(-(t - math.pi / 3 - .1) * (2 * math.pi / #thing.shapes))
  g.translate(-u / 2, -v / 2)
  g.polygon('fill', thing.lerpd)
end

return thing
