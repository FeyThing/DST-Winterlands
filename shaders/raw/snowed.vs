// Vertex shader

uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;
uniform vec3 FLOAT_PARAMS;

attribute vec4 POS2D_UV; // x, y, u + samplerIndex * 2, v

varying vec3 PS_POS;
varying vec3 PS_TEXCOORD;

#define SINK_DEPTH  FLOAT_PARAMS.y

void main()
{
	vec3 POSITION = vec3(POS2D_UV.xy, 0.0);
	float samplerIndex = floor(POS2D_UV.z / 2.0);
	vec3 TEXCOORD0 = vec3(POS2D_UV.z - 2.0 * samplerIndex, POS2D_UV.w, samplerIndex);

	vec3 object_pos = POSITION.xyz;
	vec4 world_pos = MatrixW * vec4(object_pos, 1.0);

	if (SINK_DEPTH < 0.0)
	{
		world_pos.y += SINK_DEPTH;
	}

	mat4 mtxPV = MatrixP * MatrixV;
	gl_Position = mtxPV * world_pos;

	PS_TEXCOORD = TEXCOORD0;
	PS_POS = world_pos.xyz;
}