local thing = {}
thing.background = { 20, 22, 20 }
thing.start = 100
thing.stop = 250

function thing.load()
  thing.shader = g.newShader([[
    #define COUNT 216
    uniform vec2 resolution;
    uniform vec3 blobs[COUNT];

    //  Function from Iñigo Quiles
    //  https://www.shadertoy.com/view/MsS3Wc
    vec3 hsb2rgb( in vec3 c ){
        vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
                                 6.0)-3.0)-1.0,
                         0.0,
                         1.0 );
        rgb = rgb*rgb*(3.0-2.0*rgb);
        return c.z * mix(vec3(1.0), rgb, c.y);
    }

    vec4 effect(vec4 color, Image texture, vec2 st, vec2 xy) {
      float result = 0.;
      int i;

      for (i = 0; i < COUNT; i++) {
        vec2 uv = (blobs[i].xy - xy) / resolution;
        result += blobs[i].b / length(uv) / COUNT;
      }

      float z = smoothstep(.75, 1, result);
      vec3 c = hsb2rgb(vec3(1 - (.5 + z / 3), 1, z));

      return vec4(c, z);
    }
  ]])

  g.setShader(thing.shader)
  thing.shader:send('resolution', { u, v })
end

function thing.update(dt)
  thing.circles = {}
  local distance = 80
  for i = 1, 8 do
    local count = 6 * i
    local radius = 32 / i
    for j = 1, count do
      local angle = (j / count) * (2 * math.pi)
      table.insert(thing.circles, {
        u * .5 + distance * math.cos(angle) * math.sin(t * math.pi / 3 + i * ((i % 2 == 0) and -1 or 1)),
        v * .5 + distance * math.sin(angle) * math.cos(t * math.pi / 3 + i * ((i % 2 == 0) and 1 or -1)),
        .2
      })
    end

    distance = distance + 2 * radius
  end

  thing.shader:send('blobs', unpack(thing.circles))
end

function thing.draw()
  g.clear(thing.background)
  g.setShader(thing.shader)
  g.rectangle('fill', 0, 0, u, v)
  g.setShader()
end

return thing
