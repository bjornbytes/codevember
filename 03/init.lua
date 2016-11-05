local thing = {}
thing.background = { 12, 10, 14 }
thing.width = 512
thing.height = 512
thing.rate = 40
thing.start = 40
thing.stop = 120

function thing.load()
  thing.shader = g.newShader([[
extern vec2 resolution;
extern float t;
#define PI 3.14159265358979323846264
vec4 effect(vec4 color, Image texture, vec2 st, vec2 xy) {
  vec2 uv = vec2(.5) - xy / resolution;
  float dir = .5 + atan(uv.y, uv.x) / (2 * PI);
  float len = length(uv);
  float r = .2 + sin(dir * 20 * PI + t) * cos(dir * 8 * PI + t) * .02 * sin(t);
  float w = .05 + .02 * cos(t);
  float alpha = smoothstep(len, r - w, r) - smoothstep(len, r, r + w);
  return vec4(.6, .1, 1., alpha);
}
  ]])

  g.setShader(thing.shader)
  thing.shader:send('resolution', { g.getDimensions() })
end

function thing.update(dt)
  thing.shader:send('t', t * math.pi)
end

function thing.draw()
  g.clear(thing.background)
  g.rectangle('fill', 0, 0, g.getDimensions())
end

return thing
