local thing = {}
thing.rate = 50
thing.background = { 145, 223, 231 }
thing.start = 4
thing.stop = 5

-- Converts HSL to RGB. (input and output range: 0 - 255)
function HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

local function makeDonut()
end

function thing.load()
  local outer = .4 * u
  local inner = .1 * u

  local dough = {}
  for i = 0, 360, 4 do
    local angle = (i / 360) * (2 * math.pi)
    local ix = u * .5 + inner * math.cos(angle)
    local iy = v * .5 + inner * math.sin(angle)
    local ox = u * .5 + outer * math.cos(angle)
    local oy = v * .5 + outer * math.sin(angle)
    table.insert(dough, { ix, iy })
    table.insert(dough, { ox, oy })
  end

  local icing = {}
  for i = 0, 359, 4 do
    local angle = (i / 360) * (2 * math.pi)
    local mid = (inner + outer) / 2
    local spread = .08 * u
    local noise = love.math.noise(angle + 4) * .06 * u
    local il = mid - (spread + noise)
    local ol = mid + (spread + noise)

    local ix = u * .5 + il * math.cos(angle)
    local iy = v * .5 + il * math.sin(angle)
    local ox = u * .5 + ol * math.cos(angle)
    local oy = v * .5 + ol * math.sin(angle)
    table.insert(icing, { ix, iy })
    table.insert(icing, { ox, oy })
  end

  table.insert(icing, icing[1])
  table.insert(icing, icing[2])

  local sprinkles = {}
  for i = 1, 30 do
    local direction = love.math.random() * 2 * math.pi
    local distance = love.math.random(inner * 1.5, outer * .85)
    local x = u * .5 + distance * math.cos(direction)
    local y = v * .5 + distance * math.sin(direction)
    local angle = love.math.random() * 2 * math.pi
    table.insert(sprinkles, {
      x = x,
      y = y,
      angle = angle,
      color = { HSL(love.math.random(255), 255, 200) }
    })
  end

  thing.dough = g.newMesh(dough, 'strip')
  thing.icing = g.newMesh(icing, 'strip')
  thing.sprinkles = sprinkles
end

function thing.update(dt)
  --
end

function thing.draw()
  g.clear(255, 231, 253)

  g.setColor(227, 199, 142)
  g.draw(thing.dough)

  g.stencil(function() g.draw(thing.dough) end, 'replace')
  g.stencil(function() g.circle('fill', u * .5, v * .5 - .03 * u, .12 * u) end, 'replace', 0, true)

  g.setStencilTest('greater', 0)

  g.setColor(255, 255, 255, 40)
  g.circle('fill', u * .5, v * .4, .4 * u)

  g.setStencilTest()

  g.setColor(72, 49, 14, 240)
  g.draw(thing.icing)

  for i, sprinkle in ipairs(thing.sprinkles) do
    local r = .005 * u
    local len = .02 * u
    local x, y, angle = sprinkle.x, sprinkle.y, sprinkle.angle
    local x1 = x - len / 2 * math.cos(angle)
    local y1 = y - len / 2 * math.sin(angle)
    local x2 = x + len / 2 * math.cos(angle)
    local y2 = y + len / 2 * math.sin(angle)
    g.setLineWidth(r * 2)
    g.setColor(unpack(sprinkle.color))
    g.line(x1, y1, x2, y2)
    g.circle('fill', x1, y1, r)
    g.circle('fill', x2, y2, r)
  end
end

return thing
