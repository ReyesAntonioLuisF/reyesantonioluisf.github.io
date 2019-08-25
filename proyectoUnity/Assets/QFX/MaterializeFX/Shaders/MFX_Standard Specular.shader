// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/MFX/Standard Specular"
{
	Properties
	{
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_EmissionMap("Emission Texture", 2D) = "white" {}
		[HDR]_Emission2Color("Emission2Color", Color) = (1,1,1,1)
		_EmissionMap2("Emission Texture 2", 2D) = "white" {}
		_EmissionMap2_Scroll("Emission Texture 2 Scroll", Vector) = (0,0,0,0)
		_Emission2Offset("Emission2Offset", Range( 0 , 1)) = 1
		[Toggle]_Emission2Smooth("Emission2Smooth?", Float) = 1
		[HDR]_EdgeColor("Edge Color", Color) = (1,1,1,1)
		_EdgeMap1("Edge Map", 2D) = "white" {}
		_EdgeMap1_Scroll("Edge Map Scroll", Vector) = (0,0,0,0)
		_EdgeSize("Edge Size", Range( 0 , 2)) = 0.5
		_DissolveMap1("Dissolve Map", 2D) = "white" {}
		_DissolveMap1_Scroll("Dissolve Map Scroll", Vector) = (0,0,0,0)
		_DissolveSize("Dissolve Size", Range( 0 , 1)) = 0
		_EdgeOffset("Edge Offset", Range( -1 , 1)) = 0
		[HDR]_DissolveEdgeColor("Dissolve Edge Color", Color) = (1,1,1,1)
		_DissolveEdgeSize("Dissolve Edge Size", Range( 0 , 2)) = 0
		_FlowMap("FlowMap", 2D) = "white" {}
		_FlowMap_Scroll("FlowMap_Scroll", Vector) = (0,0.2,0,0)
		_DistortionStrength("DistortionStrength", Float) = 1
		_EdgeStrength("Edge Strength", Range( 0 , 1)) = 1
		_MaskOffset("Mask Offset", Float) = 0
		_DissolveStrength("Dissolve Strength", Range( 0 , 1)) = 1
		[Toggle]_Invert("Invert", Float) = 0
		[KeywordEnum(None,AxisLocal,AxisGlobal,Global)] _MaskType("Mask Type", Float) = 2
		[KeywordEnum(X,Y,Z)] _CutoffAxis("Cutoff Axis", Float) = 1
		[Toggle]_UseObjectWorldPosition("Use Object World Position", Float) = 1
		[Toggle]_UseEmission2("UseEmission2", Float) = 1
		_MaskWorldPosition("Mask World Position", Vector) = (0,0,0,0)
		[Toggle]_Emission2Invert("Emission2Invert", Float) = 1
		_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Bump Scale", Float) = 1
		[HDR]_Color2("Albedo Color 2", Color) = (0,0,0,1)
		_MainTex2("Albedo 2", 2D) = "white" {}
		_BumpMap2("Normal Map 2", 2D) = "bump" {}
		[Toggle]_GammaToLinear("GammaToLinear", Float) = 0
		[HDR]_Color("Albedo Color", Color) = (1,1,1,1)
		[KeywordEnum(SpecularAlpha,AlbedoAlpha)] _SmoothnessTextureChannel("Smoothness Texture Channel", Float) = 0
		[Toggle(_SPECGLOSSMAP_ON)] _SPECGLOSSMAP("SPECGLOSSMAP", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.1
		[HDR]_SpecColor("Specular Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}
		_GlossMapScale("Smoothness Scale", Range( 0 , 1)) = 0
		_Glossiness("Smoothness", Range( 0 , 1)) = 0
		_SpecGlossMap("Specular Texture", 2D) = "white" {}
		_OcclusionMap("Occlusion", 2D) = "white" {}
		_OcclusionStrength("Occlusion", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma shader_feature _CUTOFFAXIS_X _CUTOFFAXIS_Y _CUTOFFAXIS_Z
		#pragma shader_feature _MASKTYPE_NONE _MASKTYPE_AXISLOCAL _MASKTYPE_AXISGLOBAL _MASKTYPE_GLOBAL
		#pragma shader_feature _SPECGLOSSMAP_ON
		#pragma shader_feature _SMOOTHNESSTEXTURECHANNEL_SPECULARALPHA _SMOOTHNESSTEXTURECHANNEL_ALBEDOALPHA
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float3 worldPos;
		};

		uniform float _BumpScale;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _BumpMap2;
		uniform float4 _BumpMap2_ST;
		uniform float _EdgeOffset;
		uniform float _UseObjectWorldPosition;
		uniform float3 _MaskWorldPosition;
		uniform float _Invert;
		uniform float _MaskOffset;
		uniform float _EdgeStrength;
		uniform sampler2D _EdgeMap1;
		uniform float2 _EdgeMap1_Scroll;
		uniform float4 _EdgeMap1_ST;
		uniform sampler2D _FlowMap;
		uniform float2 _FlowMap_Scroll;
		uniform float4 _FlowMap_ST;
		uniform float _DistortionStrength;
		uniform float _GammaToLinear;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color2;
		uniform sampler2D _MainTex2;
		uniform float4 _MainTex2_ST;
		uniform float _DissolveSize;
		uniform float _DissolveStrength;
		uniform sampler2D _DissolveMap1;
		uniform float2 _DissolveMap1_Scroll;
		uniform float4 _DissolveMap1_ST;
		uniform float _DissolveEdgeSize;
		uniform float4 _DissolveEdgeColor;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float _Emission2Smooth;
		uniform float4 _Emission2Color;
		uniform sampler2D _EmissionMap2;
		uniform float2 _EmissionMap2_Scroll;
		uniform float4 _EmissionMap2_ST;
		uniform float _UseEmission2;
		uniform float _Emission2Invert;
		uniform float _Emission2Offset;
		uniform float4 _EdgeColor;
		uniform float _EdgeSize;
		uniform float _Glossiness;
		uniform float _GlossMapScale;
		uniform sampler2D _SpecGlossMap;
		uniform sampler2D _OcclusionMap;
		uniform float _OcclusionStrength;
		uniform float _Cutoff = 0.1;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv0_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float2 uv2_BumpMap2 = i.uv2_texcoord2 * _BumpMap2_ST.xy + _BumpMap2_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float4 transform228_g26 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 temp_cast_2 = (1.0).xxxx;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 temp_cast_6 = (length( ( ase_worldPos - _MaskWorldPosition ) )).xxxx;
			#if defined(_MASKTYPE_NONE)
				float4 staticSwitch10_g26 = temp_cast_2;
			#elif defined(_MASKTYPE_AXISLOCAL)
				float4 staticSwitch10_g26 = float4( ase_vertex3Pos , 0.0 );
			#elif defined(_MASKTYPE_AXISGLOBAL)
				float4 staticSwitch10_g26 = lerp(float4( ase_worldPos , 0.0 ),( float4( ase_worldPos , 0.0 ) - transform228_g26 ),_UseObjectWorldPosition);
			#elif defined(_MASKTYPE_GLOBAL)
				float4 staticSwitch10_g26 = temp_cast_6;
			#else
				float4 staticSwitch10_g26 = lerp(float4( ase_worldPos , 0.0 ),( float4( ase_worldPos , 0.0 ) - transform228_g26 ),_UseObjectWorldPosition);
			#endif
			float4 break13_g26 = staticSwitch10_g26;
			#if defined(_CUTOFFAXIS_X)
				float staticSwitch20_g26 = break13_g26.x;
			#elif defined(_CUTOFFAXIS_Y)
				float staticSwitch20_g26 = break13_g26.y;
			#elif defined(_CUTOFFAXIS_Z)
				float staticSwitch20_g26 = break13_g26.z;
			#else
				float staticSwitch20_g26 = break13_g26.y;
			#endif
			float mfx_pos25_g26 = staticSwitch20_g26;
			float mfx_invert_option23_g26 = lerp(1.0,-1.0,_Invert);
			float temp_output_28_0_g26 = ( mfx_invert_option23_g26 * _MaskOffset );
			float mfx_mask_pos40_g26 = ( ( mfx_pos25_g26 * mfx_invert_option23_g26 ) - temp_output_28_0_g26 );
			float2 uv0_EdgeMap1 = i.uv_texcoord * _EdgeMap1_ST.xy + _EdgeMap1_ST.zw;
			float2 panner27_g26 = ( 1.0 * _Time.y * _EdgeMap1_Scroll + uv0_EdgeMap1);
			float2 uv0_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 panner232_g26 = ( 1.0 * _Time.y * _FlowMap_Scroll + uv0_FlowMap);
			float2 flow_mapa235_g26 = ( (tex2D( _FlowMap, panner232_g26 )).rg * _DistortionStrength );
			float mfx_edge_pos55_g26 = ( 1.0 - ( ( ( _EdgeOffset + mfx_mask_pos40_g26 ) / _EdgeStrength ) - ( temp_output_28_0_g26 - tex2D( _EdgeMap1, ( panner27_g26 + flow_mapa235_g26 ) ).r ) ) );
			float temp_output_65_0_g26 = ceil( mfx_edge_pos55_g26 );
			float temp_output_84_0_g26 = saturate( temp_output_65_0_g26 );
			float mfx_edge_threshold108_g26 = temp_output_84_0_g26;
			float temp_output_32_0_g27 = mfx_edge_threshold108_g26;
			float3 lerpResult28_g27 = lerp( UnpackScaleNormal( tex2D( _BumpMap, uv0_BumpMap ), _BumpScale ) , UnpackNormal( tex2D( _BumpMap2, uv2_BumpMap2 ) ) , temp_output_32_0_g27);
			float3 mfx_norma14_g27 = lerpResult28_g27;
			o.Normal = mfx_norma14_g27;
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode28 = tex2D( _MainTex, uv0_MainTex );
			float2 uv_MainTex2 = i.uv_texcoord * _MainTex2_ST.xy + _MainTex2_ST.zw;
			float4 lerpResult9_g27 = lerp( ( _Color * tex2DNode28 ) , ( _Color2 * tex2D( _MainTex2, uv_MainTex2 ) ) , temp_output_32_0_g27);
			float4 myVarName18_g27 = lerpResult9_g27;
			float3 gammaToLinear37_g27 = GammaToLinearSpace( myVarName18_g27.rgb );
			o.Albedo = lerp(myVarName18_g27,float4( gammaToLinear37_g27 , 0.0 ),_GammaToLinear).rgb;
			float2 uv0_DissolveMap1 = i.uv_texcoord * _DissolveMap1_ST.xy + _DissolveMap1_ST.zw;
			float2 panner83_g26 = ( 1.0 * _Time.y * _DissolveMap1_Scroll + uv0_DissolveMap1);
			float mfx_alpha141_g26 = ( ( ( _DissolveSize + mfx_mask_pos40_g26 ) / _DissolveStrength ) - ( temp_output_28_0_g26 - tex2D( _DissolveMap1, ( panner83_g26 + flow_mapa235_g26 ) ).r ) );
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 uv0_EmissionMap2 = i.uv_texcoord * _EmissionMap2_ST.xy + _EmissionMap2_ST.zw;
			float2 panner22_g26 = ( 1.0 * _Time.y * _EmissionMap2_Scroll + uv0_EmissionMap2);
			float4 tex2DNode29_g26 = tex2D( _EmissionMap2, panner22_g26 );
			float clampResult53_g26 = clamp( ( ( ( 1.0 - tex2DNode29_g26.r ) - 0.5 ) * 3.0 ) , 0.0 , 1.0 );
			float4 mfx_emission_297_g26 = lerp(( _Emission2Color * tex2DNode29_g26.r ),( _Emission2Color * ( lerp(1.0,pow( clampResult53_g26 , 3.0 ),_UseEmission2) * saturate( ( lerp(( 1.0 - mfx_edge_pos55_g26 ),mfx_edge_pos55_g26,_Emission2Invert) + _Emission2Offset ) ) ) ),_Emission2Smooth);
			float4 lerpResult113_g26 = lerp( ( _EmissionColor * tex2D( _EmissionMap, uv_EmissionMap ) ) , mfx_emission_297_g26 , mfx_edge_threshold108_g26);
			float4 mfx_emission129_g26 = lerpResult113_g26;
			float temp_output_66_0_g26 = ( 1.0 - _EdgeSize );
			float smoothstepResult85_g26 = smoothstep( temp_output_66_0_g26 , ( temp_output_66_0_g26 + 0.1 ) , ( 1.0 - abs( mfx_edge_pos55_g26 ) ));
			float mfx_edge119_g26 = saturate( ( smoothstepResult85_g26 - temp_output_84_0_g26 ) );
			float4 mfx_final_emission181_g26 = (( mfx_alpha141_g26 <= _DissolveEdgeSize ) ? _DissolveEdgeColor :  ( mfx_emission129_g26 + ( _EdgeColor * mfx_edge119_g26 ) ) );
			o.Emission = mfx_final_emission181_g26.rgb;
			float4 break37_g23 = _SpecColor;
			float4 appendResult23_g23 = (float4(break37_g23.r , break37_g23.g , break37_g23.b , _Glossiness));
			float temp_output_33_0_g23 = _GlossMapScale;
			float temp_output_38_0_g23 = _Color.a;
			float4 appendResult17_g23 = (float4(break37_g23.r , break37_g23.g , break37_g23.b , ( temp_output_33_0_g23 * temp_output_38_0_g23 )));
			#if defined(_SMOOTHNESSTEXTURECHANNEL_SPECULARALPHA)
				float staticSwitch10_g23 = 0.0;
			#elif defined(_SMOOTHNESSTEXTURECHANNEL_ALBEDOALPHA)
				float staticSwitch10_g23 = 1.0;
			#else
				float staticSwitch10_g23 = 0.0;
			#endif
			float texturechannel18_g23 = staticSwitch10_g23;
			float4 lerpResult25_g23 = lerp( appendResult23_g23 , appendResult17_g23 , texturechannel18_g23);
			float4 break35_g23 = tex2D( _SpecGlossMap, uv0_MainTex );
			float4 appendResult21_g23 = (float4(break35_g23.r , break35_g23.g , break35_g23.b , ( break35_g23.a * temp_output_33_0_g23 )));
			float4 appendResult22_g23 = (float4(break35_g23.r , break35_g23.g , break35_g23.b , ( temp_output_33_0_g23 * temp_output_38_0_g23 )));
			float4 lerpResult24_g23 = lerp( appendResult21_g23 , appendResult22_g23 , texturechannel18_g23);
			#ifdef _SPECGLOSSMAP_ON
				float4 staticSwitch26_g23 = lerpResult24_g23;
			#else
				float4 staticSwitch26_g23 = lerpResult25_g23;
			#endif
			float4 break27_g23 = staticSwitch26_g23;
			float3 appendResult28_g23 = (float3(break27_g23.x , break27_g23.y , break27_g23.z));
			float3 Specular122 = appendResult28_g23;
			o.Specular = Specular122;
			float Smoothness121 = break27_g23.w;
			o.Smoothness = Smoothness121;
			float lerpResult128 = lerp( 1.0 , tex2D( _OcclusionMap, uv0_MainTex ).r , _OcclusionStrength);
			float occlusion129 = lerpResult128;
			o.Occlusion = occlusion129;
			o.Alpha = 1;
			clip( ( mfx_alpha141_g26 * tex2DNode28.a ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "MfxShaderGui"
}
/*ASEBEGIN
Version=16700
41;335;1321;406;3625.478;-198.6052;1.804912;True;True
Node;AmplifyShaderEditor.CommentaryNode;115;-3340.674,-689.2037;Float;False;1780.834;731.0764;;7;117;121;122;555;815;816;817;Specular & Smoothness;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;125;-3322.319,858.9627;Float;False;832.5983;527.703;;5;562;129;128;126;127;Ambient Occlusion;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;555;-3260.619,-566.5344;Float;False;0;28;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;562;-3281.852,957.5607;Float;False;0;28;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;139;-3320.385,153.1452;Float;False;608.3228;625.7384;;4;29;28;27;561;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-3283.401,1286.06;Float;False;Property;_OcclusionStrength;Occlusion;51;0;Create;False;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;815;-2919.588,-395.6862;Float;False;Property;_SpecColor;Specular Color;45;1;[HDR];Fetch;False;0;0;False;0;1,1,1,1;0.8235294,0.8235294,0.8235294,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;117;-3008.983,-590.2652;Float;True;Property;_SpecGlossMap;Specular Texture;49;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;816;-2989.776,-175.7242;Float;False;Property;_Glossiness;Smoothness;48;0;Create;False;0;0;False;0;0;0.917;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;126;-3283.401,1078.061;Float;True;Property;_OcclusionMap;Occlusion;50;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;561;-3239.689,588.5475;Float;False;0;28;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;817;-2988.712,-93.46239;Float;False;Property;_GlossMapScale;Smoothness Scale;47;0;Create;False;0;0;False;0;0;0.917;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-3160.203,237.3555;Float;False;Property;_Color;Albedo Color;40;1;[HDR];Create;False;0;0;False;0;1,1,1,1;0.8235294,0.8235294,0.8235294,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;128;-2944.271,1154.463;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;821;-2574.544,-384.1932;Float;False;GetSpecularSmoothness;41;;23;bad312ca98f83b74eb4775f8556ee7b7;0;5;34;COLOR;0,0,0,0;False;36;COLOR;0,0,0,0;False;32;FLOAT;0;False;33;FLOAT;0;False;38;FLOAT;0;False;2;FLOAT3;0;FLOAT;31
Node;AmplifyShaderEditor.SamplerNode;28;-3240.816,404.1202;Float;True;Property;_MainTex;Albedo;46;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-2041.952,-429.075;Float;False;Specular;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;824;-2595.054,502.6152;Float;False;GetMfx;0;;26;fb2280b00bae11444805a18d6fdcad02;0;1;217;COLOR;0,0,0,0;False;3;COLOR;199;FLOAT;201;FLOAT;222
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-2045.965,-326.3509;Float;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2880.561,384.9582;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-2760.172,1151.04;Float;False;occlusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-2082.467,782.1889;Float;False;121;Smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;826;-2260.061,591.1736;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-2070.423,861.786;Float;False;129;occlusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;825;-2251.297,211.7086;Float;False;GetMfxAlbedoNormal;31;;27;970bdfdf67ef7df4f8c4f062e76ba030;0;3;32;FLOAT;0;False;18;FLOAT3;0,0,0;False;22;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT3;35
Node;AmplifyShaderEditor.GetLocalVarNode;123;-2063.866,698.689;Float;False;122;Specular;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1779.987,284.4162;Float;False;True;2;Float;MfxShaderGui;0;0;StandardSpecular;QFX/MFX/Standard Specular;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.1;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;44;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;405;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;117;1;555;0
WireConnection;126;1;562;0
WireConnection;128;1;126;1
WireConnection;128;2;127;0
WireConnection;821;34;117;0
WireConnection;821;36;815;0
WireConnection;821;32;816;0
WireConnection;821;33;817;0
WireConnection;821;38;27;4
WireConnection;28;1;561;0
WireConnection;122;0;821;0
WireConnection;121;0;821;31
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;129;0;128;0
WireConnection;826;0;824;201
WireConnection;826;1;28;4
WireConnection;825;32;824;222
WireConnection;825;22;29;0
WireConnection;0;0;825;0
WireConnection;0;1;825;35
WireConnection;0;2;824;199
WireConnection;0;3;123;0
WireConnection;0;4;124;0
WireConnection;0;5;130;0
WireConnection;0;10;826;0
ASEEND*/
//CHKSM=72097F613194E29DA6EF7F5ABDA901A615DBA730