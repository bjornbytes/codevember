local thing = {}
thing.start = 3 * 50
thing.stop = 7 * 50

function thing.load()
  thing.shader = g.newShader([[
    uniform vec2 uv;
    uniform float t;
    #define PI 3.141592653589793238462643383279502

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
      int steps = 70;
      float scale = 3;
      vec2 uv = vec2((scale - 1.5) / 2, scale / 2) - scale * xy / uv;

      int i;
      vec2 z = uv;
      for (i = 0; i < steps; i++) {
        float x = (z.x * z.x - z.y * z.y) + uv.x;
        float y = (z.y * z.x + z.x * z.y) + uv.y;

        if (x * x + y * y > 4.) { break; }

        z.x = x;
        z.y = y;
      }

      if (i == steps) {
        return vec4(0., 0., 0., 1.);
      }

      float factor = (1 - float(i) / steps);
      float h = .75;
      float s = factor * (.5 + (.5 + cos((1 - factor) * 30 + t * PI) / 2)) / 2;
      float b = clamp(pow(5 + 1 - factor, .5), 0, 1);
      vec3 c = hsb2rgb(vec3(h, s, b));

      return vec4(c, 1.);
    }
  ]])

  thing.shader:send('uv', { u, v })
  g.setShader(thing.shader)
end

function thing.update()
  thing.shader:send('t', t)
end

function thing.draw()
  g.rectangle('fill', 0, 0, g.getDimensions())
end

return thing
