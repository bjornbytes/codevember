local thing = {}
thing.width = 512
thing.height = 512
thing.start = 50
thing.stop = 150
thing.radius = 80
thing.rate = 50

local function dx(len, dir) return len * math.cos(dir) end
local function dy(len, dir) return len * math.sin(dir) end

function thing.load()
  thing.count = 36
  thing.shader = g.newShader([[
    #define COUNT ]] .. thing.count .. [[ 
    uniform vec2 resolution;
    uniform vec3 blobs[COUNT];
    vec4 effect(vec4 color, Image texture, vec2 st, vec2 xy) {
      float result = 0.;
      int i;

      for (i = 0; i < COUNT; i++) {
        vec2 uv = (blobs[i].xy - xy) / resolution;
        result += blobs[i].b / length(uv);
      }

      vec3 c = mix(vec3(0.), vec3(.5, 0, 1.), result);

      return vec4(c, 1.);
    }
  ]])

  g.setShader(thing.shader)
  thing.shader:send('resolution', { u, v })
end

function thing.update(dt)
  local blobs = {}
  local t = t * math.pi / 2
  local r = .0025

  for i = 1, 6 do
    for j = 1, 6 do
      local angle = i * t + j / 6 * 2 * math.pi
      local d = .1171 * v * ((6 - i) / 2)
      local x = u * .5 + dx(d, angle) * math.abs(math.sin(t))
      local y = v * .5 + dy(d, angle) * math.abs(math.cos(t))
      table.insert(blobs, { x, y, r })
    end
  end

  thing.shader:send('blobs', unpack(blobs))
end

function thing.draw()
  g.rectangle('fill', 0, 0, u, v)
end

return thing
