// Invert all screen colors (Matt's "dark mode").  Toggled by scripts/invert.sh.
#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
layout(location = 0) out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);
    fragColor = vec4(1.0 - color.rgb, color.a);
}
