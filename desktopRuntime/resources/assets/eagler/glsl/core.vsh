#line 2

/*
 * Copyright (c) 2022-2024 lax1dude. All Rights Reserved.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */

EAGLER_IN_AUTO(vec3, a_position3f)

#if defined(COMPILE_ENABLE_TEX_GEN) || defined(COMPILE_ENABLE_FOG)
#define _COMPILE_VARYING_POSITION
#endif

#ifdef _COMPILE_VARYING_POSITION
EAGLER_OUT(vec4, v_position4f)
#endif

#ifdef COMPILE_ENABLE_TEX_GEN
EAGLER_OUT(vec3, v_objectPosition3f)
#endif

#ifdef COMPILE_TEXTURE_ATTRIB
EAGLER_IN_AUTO(vec2, a_texture2f)
EAGLER_OUT(vec2, v_texture2f)
uniform mat4 u_textureMat4f01;
#endif

#ifdef COMPILE_COLOR_ATTRIB
EAGLER_IN_AUTO(vec4, a_color4f)
EAGLER_OUT(vec4, v_color4f)
#endif

#ifdef COMPILE_NORMAL_ATTRIB
EAGLER_IN_AUTO(vec4, a_normal4f)
EAGLER_OUT(vec3, v_normal3f)
#endif

#ifdef COMPILE_LIGHTMAP_ATTRIB
EAGLER_IN_AUTO(vec2, a_lightmap2f)
EAGLER_OUT(vec2, v_lightmap2f)
uniform mat4 u_textureMat4f02;
#endif

#ifdef _COMPILE_VARYING_POSITION
uniform mat4 u_modelviewMat4f;
uniform mat4 u_projectionMat4f;
#else
uniform mat4 u_modelviewProjMat4f;
#ifdef COMPILE_NORMAL_ATTRIB
uniform mat4 u_modelviewMat4f;
#endif
#endif

#define TEX_MAT3(mat4In) mat3(mat4In[0].xyw,mat4In[1].xyw,mat4In[3].xyw)

void main() {
#ifdef COMPILE_ENABLE_TEX_GEN
	v_objectPosition3f = a_position3f;
#endif

#ifdef _COMPILE_VARYING_POSITION
	v_position4f = u_modelviewMat4f * vec4(a_position3f, 1.0);
#endif

#ifdef COMPILE_TEXTURE_ATTRIB
	vec3 v_textureTmp3f = TEX_MAT3(u_textureMat4f01) * vec3(a_texture2f, 1.0);
	v_texture2f = v_textureTmp3f.xy / v_textureTmp3f.z;
#endif
	
#ifdef COMPILE_COLOR_ATTRIB
	v_color4f = a_color4f;
#endif
	
#ifdef COMPILE_NORMAL_ATTRIB
	v_normal3f = normalize(mat3(u_modelviewMat4f) * a_normal4f.xyz);
#endif
	
#ifdef COMPILE_LIGHTMAP_ATTRIB
	vec3 v_lightmapTmp3f = TEX_MAT3(u_textureMat4f02) * vec3(a_lightmap2f, 1.0);
	v_lightmap2f = v_lightmapTmp3f.xy / v_lightmapTmp3f.z;
#endif

#ifdef _COMPILE_VARYING_POSITION
	EAGLER_VERT_POSITION = u_projectionMat4f * v_position4f;
#else
	EAGLER_VERT_POSITION = u_modelviewProjMat4f * vec4(a_position3f, 1.0);
#endif
}
