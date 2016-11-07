local thing = {}
thing.start = 40
thing.stop = 150
thing.rate = 50
thing.background = { 0, 30, 50 }
thing.color = { 0, 180, 220 }

local function dx(len, dir) return len * math.cos(dir) end
local function dy(len, dir) return len * math.sin(dir) end

function thing.load()
  thing.shader = g.newShader([[
    #define COUNT 32
    uniform vec2 resolution;
    uniform vec3 blobs[COUNT];
    vec4 effect(vec4 color, Image texture, vec2 st, vec2 xy) {
      float result = 0.;
      int i;

      for (i = 0; i < COUNT; i++) {
        vec2 uv = (blobs[i].xy - xy) / resolution;
        result += blobs[i].b / length(uv) / COUNT;
      }

      float c = smoothstep(.92, 1, result);

      return color * vec4(c);
    }
  ]])

  g.setShader(thing.shader)
  thing.shader:send('resolution', { u, v })
end

function thing.update(dt)
  local blobs = {}

  for i = 1, 8 do
    local offset = (i / 8) * 2 * math.pi
    for j = 1, 4 do
      local angle = offset + j / 4 * 2 * math.pi
      local distance = (u * .3 / 8) * i * (.5 + math.cos(t * math.pi + j / 4) / 2) ^ (2 / i)
      local x = u * .5 + dx(distance, angle)
      local y = v * .5 + dy(distance, angle)
      table.insert(blobs, { x, y, .1 })
    end
  end

  thing.shader:send('blobs', unpack(blobs))
end

function thing.draw()
  g.clear(thing.background)
  g.setColor(thing.color)
  g.rectangle('fill', 0, 0, u, v)
end

return thing
