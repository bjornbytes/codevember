local thing = {}
thing.background = { 40, 50, 60 }
thing.rate = 50
thing.start = 50
thing.stop = 250

local function copy(t)
  if type(t) ~= 'table' then return t end
  local res = {}
  for k, v in next, t, nil do res[k] = copy(v) end
  return res
end

local function lerp(x, y, z)
  return x + (y - x) * z
end

local function tlerp(t1, t2, z)
  local lerpd = copy(t1)
  for k, v in pairs(lerpd) do
    if t2[k] then
      if type(v) == 'table' then lerpd[k] = tlerp(t1[k], t2[k], z)
      elseif type(v) == 'number' then
        lerpd[k] = lerp(t1[k], t2[k], z)
      end
    end
  end
  return lerpd
end

function thing.load()
  thing.thickness = 16
  local nudge = thing.thickness * .67

  thing.yes = {
    color = { 120, 200, 120 },
    icon = {
      {
        u * .48, u * .55,
        u * .43, u * .5,
      },
      {
        u * .48 - nudge, u * .55,
        u * .58 - nudge, u * .45,
      },
      {
        u * .48, u * .55,
        u * .43, u * .5,
      },
      {
        u * .48 - nudge, u * .55,
        u * .58 - nudge, u * .45,
      },
    }
  }

  thing.no = {
    color = { 200, 80, 80 },
    icon = {
      {
        u * .5, u * .5,
        u * .45, u * .45
      },
      {
        u * .5, u * .5,
        u * .55, u * .45
      },
      {
        u * .5, u * .5,
        u * .55, u * .55
      },
      {
        u * .5, u * .5,
        u * .45, u * .55
      },
    }
  }

  thing.lerpd = copy(thing.yes)

  thing.factor = 0
end

function thing.update(dt)
  local x = 2 * (t - math.floor(t))
  if x < 1 then
    x = .5 * (x ^ 2)
  else
    x = 2 - x
    x = .5 * (1 - x ^ 2) + .5
  end

  thing.lerpd = tlerp(thing.lerpd, t % 2 > 1 and thing.no or thing.yes, x)
end

function thing.draw()
  g.clear(thing.background)
  g.setColor(thing.lerpd.color)
  g.setLineWidth(thing.thickness)

  for i = 1, #thing.lerpd.icon do
    g.line(thing.lerpd.icon[i])
  end
end

return thing
