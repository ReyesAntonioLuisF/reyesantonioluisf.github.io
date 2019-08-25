// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/MFX/Standard"
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
		[Toggle(_METALLICGLOSSMAP_ON)] _METALLICGLOSSMAP("METALLICGLOSSMAP", Float) = 0
		[KeywordEnum(MetallicAlpha,AlbedoAlpha)] _SmoothnessTextureChannel("Smoothness Texture Channel", Float) = 0
		_MainTex("Albedo", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.1
		_GlossMapScale("Smoothness Scale", Range( 0 , 1)) = 0
		_Glossiness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_MetallicGlossMap("Metallic Texture", 2D) = "white" {}
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
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+2450" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma shader_feature _CUTOFFAXIS_X _CUTOFFAXIS_Y _CUTOFFAXIS_Z
		#pragma shader_feature _MASKTYPE_NONE _MASKTYPE_AXISLOCAL _MASKTYPE_AXISGLOBAL _MASKTYPE_GLOBAL
		#pragma shader_feature _METALLICGLOSSMAP_ON
		#pragma shader_feature _SMOOTHNESSTEXTURECHANNEL_METALLICALPHA _SMOOTHNESSTEXTURECHANNEL_ALBEDOALPHA
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
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
		uniform float _Metallic;
		uniform float _Glossiness;
		uniform float _GlossMapScale;
		uniform sampler2D _MetallicGlossMap;
		uniform sampler2D _OcclusionMap;
		uniform float _OcclusionStrength;
		uniform float _Cutoff = 0.1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv0_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float2 uv2_BumpMap2 = i.uv2_texcoord2 * _BumpMap2_ST.xy + _BumpMap2_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float4 transform228_g44 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 temp_cast_2 = (1.0).xxxx;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 temp_cast_6 = (length( ( ase_worldPos - _MaskWorldPosition ) )).xxxx;
			#if defined(_MASKTYPE_NONE)
				float4 staticSwitch10_g44 = temp_cast_2;
			#elif defined(_MASKTYPE_AXISLOCAL)
				float4 staticSwitch10_g44 = float4( ase_vertex3Pos , 0.0 );
			#elif defined(_MASKTYPE_AXISGLOBAL)
				float4 staticSwitch10_g44 = lerp(float4( ase_worldPos , 0.0 ),( float4( ase_worldPos , 0.0 ) - transform228_g44 ),_UseObjectWorldPosition);
			#elif defined(_MASKTYPE_GLOBAL)
				float4 staticSwitch10_g44 = temp_cast_6;
			#else
				float4 staticSwitch10_g44 = lerp(float4( ase_worldPos , 0.0 ),( float4( ase_worldPos , 0.0 ) - transform228_g44 ),_UseObjectWorldPosition);
			#endif
			float4 break13_g44 = staticSwitch10_g44;
			#if defined(_CUTOFFAXIS_X)
				float staticSwitch20_g44 = break13_g44.x;
			#elif defined(_CUTOFFAXIS_Y)
				float staticSwitch20_g44 = break13_g44.y;
			#elif defined(_CUTOFFAXIS_Z)
				float staticSwitch20_g44 = break13_g44.z;
			#else
				float staticSwitch20_g44 = break13_g44.y;
			#endif
			float mfx_pos25_g44 = staticSwitch20_g44;
			float mfx_invert_option23_g44 = lerp(1.0,-1.0,_Invert);
			float temp_output_28_0_g44 = ( mfx_invert_option23_g44 * _MaskOffset );
			float mfx_mask_pos40_g44 = ( ( mfx_pos25_g44 * mfx_invert_option23_g44 ) - temp_output_28_0_g44 );
			float2 uv0_EdgeMap1 = i.uv_texcoord * _EdgeMap1_ST.xy + _EdgeMap1_ST.zw;
			float2 panner27_g44 = ( 1.0 * _Time.y * _EdgeMap1_Scroll + uv0_EdgeMap1);
			float2 uv0_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 panner232_g44 = ( 1.0 * _Time.y * _FlowMap_Scroll + uv0_FlowMap);
			float2 flow_mapa235_g44 = ( (tex2D( _FlowMap, panner232_g44 )).rg * _DistortionStrength );
			float mfx_edge_pos55_g44 = ( 1.0 - ( ( ( _EdgeOffset + mfx_mask_pos40_g44 ) / _EdgeStrength ) - ( temp_output_28_0_g44 - tex2D( _EdgeMap1, ( panner27_g44 + flow_mapa235_g44 ) ).r ) ) );
			float temp_output_65_0_g44 = ceil( mfx_edge_pos55_g44 );
			float temp_output_84_0_g44 = saturate( temp_output_65_0_g44 );
			float mfx_edge_threshold108_g44 = temp_output_84_0_g44;
			float temp_output_32_0_g45 = mfx_edge_threshold108_g44;
			float3 lerpResult28_g45 = lerp( UnpackScaleNormal( tex2D( _BumpMap, uv0_BumpMap ), _BumpScale ) , UnpackNormal( tex2D( _BumpMap2, uv2_BumpMap2 ) ) , temp_output_32_0_g45);
			float3 mfx_norma14_g45 = lerpResult28_g45;
			o.Normal = mfx_norma14_g45;
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode28 = tex2D( _MainTex, uv0_MainTex );
			float2 uv_MainTex2 = i.uv_texcoord * _MainTex2_ST.xy + _MainTex2_ST.zw;
			float4 lerpResult9_g45 = lerp( ( _Color * tex2DNode28 ) , ( _Color2 * tex2D( _MainTex2, uv_MainTex2 ) ) , temp_output_32_0_g45);
			float4 myVarName18_g45 = lerpResult9_g45;
			float3 gammaToLinear37_g45 = GammaToLinearSpace( myVarName18_g45.rgb );
			o.Albedo = lerp(myVarName18_g45,float4( gammaToLinear37_g45 , 0.0 ),_GammaToLinear).rgb;
			float2 uv0_DissolveMap1 = i.uv_texcoord * _DissolveMap1_ST.xy + _DissolveMap1_ST.zw;
			float2 panner83_g44 = ( 1.0 * _Time.y * _DissolveMap1_Scroll + uv0_DissolveMap1);
			float mfx_alpha141_g44 = ( ( ( _DissolveSize + mfx_mask_pos40_g44 ) / _DissolveStrength ) - ( temp_output_28_0_g44 - tex2D( _DissolveMap1, ( panner83_g44 + flow_mapa235_g44 ) ).r ) );
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 uv0_EmissionMap2 = i.uv_texcoord * _EmissionMap2_ST.xy + _EmissionMap2_ST.zw;
			float2 panner22_g44 = ( 1.0 * _Time.y * _EmissionMap2_Scroll + uv0_EmissionMap2);
			float4 tex2DNode29_g44 = tex2D( _EmissionMap2, panner22_g44 );
			float clampResult53_g44 = clamp( ( ( ( 1.0 - tex2DNode29_g44.r ) - 0.5 ) * 3.0 ) , 0.0 , 1.0 );
			float4 mfx_emission_297_g44 = lerp(( _Emission2Color * tex2DNode29_g44.r ),( _Emission2Color * ( lerp(1.0,pow( clampResult53_g44 , 3.0 ),_UseEmission2) * saturate( ( lerp(( 1.0 - mfx_edge_pos55_g44 ),mfx_edge_pos55_g44,_Emission2Invert) + _Emission2Offset ) ) ) ),_Emission2Smooth);
			float4 lerpResult113_g44 = lerp( ( _EmissionColor * tex2D( _EmissionMap, uv_EmissionMap ) ) , mfx_emission_297_g44 , mfx_edge_threshold108_g44);
			float4 mfx_emission129_g44 = lerpResult113_g44;
			float temp_output_66_0_g44 = ( 1.0 - _EdgeSize );
			float smoothstepResult85_g44 = smoothstep( temp_output_66_0_g44 , ( temp_output_66_0_g44 + 0.1 ) , ( 1.0 - abs( mfx_edge_pos55_g44 ) ));
			float mfx_edge119_g44 = saturate( ( smoothstepResult85_g44 - temp_output_84_0_g44 ) );
			float4 mfx_final_emission181_g44 = (( mfx_alpha141_g44 <= _DissolveEdgeSize ) ? _DissolveEdgeColor :  ( mfx_emission129_g44 + ( _EdgeColor * mfx_edge119_g44 ) ) );
			o.Emission = mfx_final_emission181_g44.rgb;
			float temp_output_38_0_g21 = _Metallic;
			float2 appendResult19_g21 = (float2(temp_output_38_0_g21 , _Glossiness));
			float temp_output_40_0_g21 = _GlossMapScale;
			float temp_output_42_0_g21 = tex2DNode28.a;
			float2 appendResult23_g21 = (float2(temp_output_38_0_g21 , ( temp_output_40_0_g21 * temp_output_42_0_g21 )));
			#if defined(_SMOOTHNESSTEXTURECHANNEL_METALLICALPHA)
				float staticSwitch45_g21 = 0.0;
			#elif defined(_SMOOTHNESSTEXTURECHANNEL_ALBEDOALPHA)
				float staticSwitch45_g21 = 1.0;
			#else
				float staticSwitch45_g21 = 0.0;
			#endif
			float texturechannel46_g21 = staticSwitch45_g21;
			float2 lerpResult25_g21 = lerp( appendResult19_g21 , appendResult23_g21 , texturechannel46_g21);
			float4 tex2DNode117 = tex2D( _MetallicGlossMap, uv0_MainTex );
			float2 appendResult645 = (float2(tex2DNode117.r , tex2DNode117.a));
			float2 break37_g21 = appendResult645;
			float2 appendResult21_g21 = (float2(break37_g21.x , ( break37_g21.y * temp_output_40_0_g21 )));
			float2 appendResult20_g21 = (float2(break37_g21.x , ( temp_output_42_0_g21 * temp_output_40_0_g21 )));
			float2 lerpResult24_g21 = lerp( appendResult21_g21 , appendResult20_g21 , texturechannel46_g21);
			#ifdef _METALLICGLOSSMAP_ON
				float2 staticSwitch26_g21 = lerpResult24_g21;
			#else
				float2 staticSwitch26_g21 = lerpResult25_g21;
			#endif
			float2 break27_g21 = staticSwitch26_g21;
			float Metallic122 = break27_g21.x;
			o.Metallic = Metallic122;
			float Smothness121 = break27_g21.y;
			o.Smoothness = Smothness121;
			float lerpResult128 = lerp( 1.0 , tex2D( _OcclusionMap, uv0_MainTex ).r , _OcclusionStrength);
			float occlusion129 = lerpResult128;
			o.Occlusion = occlusion129;
			o.Alpha = 1;
			clip( ( mfx_alpha141_g44 * tex2DNode28.a ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "MfxShaderGui"
}
/*ASEBEGIN
Version=16700
41;335;1321;406;7737.078;1417.971;5.074718;True;True
Node;AmplifyShaderEditor.CommentaryNode;115;-4321.556,-1441.746;Float;False;1566.448;606.3427;;9;121;122;534;645;116;118;117;555;648;Metallic & Smoothness;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;139;-4320.757,-767.0082;Float;False;547.281;621.5758;;4;827;28;27;561;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;125;-4296.333,-42.06279;Float;False;832.5983;527.703;;5;562;129;128;126;127;Ambient Occlusion;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;555;-4241.501,-1319.077;Float;False;0;28;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;561;-4255.618,-319.5062;Float;False;0;28;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;117;-3989.865,-1342.808;Float;True;Property;_MetallicGlossMap;Metallic Texture;49;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;562;-4222.792,33.71973;Float;False;0;28;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;534;-3967.53,-958.8792;Float;False;Property;_GlossMapScale;Smoothness Scale;46;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-3970.802,-1047.766;Float;False;Property;_Glossiness;Smoothness;47;0;Create;False;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-3969.962,-1133.592;Float;False;Property;_Metallic;Metallic;48;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-4278.006,-513.9833;Float;True;Property;_MainTex;Albedo;44;0;Create;False;0;0;False;0;None;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;645;-3701.647,-1300.939;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-4224.341,362.2188;Float;False;Property;_OcclusionStrength;Occlusion;51;0;Create;False;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;126;-4224.341,154.22;Float;True;Property;_OcclusionMap;Occlusion;50;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;648;-3444.824,-1162.344;Float;False;GetMetallicSmoothness;41;;21;6d504252d6074bc4093c6306b92e1b21;0;5;42;FLOAT;0;False;33;FLOAT2;0,0;False;38;FLOAT;0;False;39;FLOAT;0;False;40;FLOAT;0;False;2;FLOAT;0;FLOAT;30
Node;AmplifyShaderEditor.LerpOp;128;-3885.207,230.6219;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-4258.81,-684.687;Float;False;Property;_Color;Albedo Color;40;1;[HDR];Create;False;0;0;False;0;1,1,1,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-3022.834,-1181.618;Float;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;876;-3693.343,-524.0628;Float;False;GetMfx;0;;44;fb2280b00bae11444805a18d6fdcad02;0;1;217;COLOR;0,0,0,0;False;3;COLOR;199;FLOAT;201;FLOAT;222
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-3026.847,-1078.893;Float;False;Smothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;827;-4031.79,-618.3522;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-3701.109,227.1988;Float;False;occlusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-3121.486,-293.524;Float;False;121;Smothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-3108.585,-377.0239;Float;False;122;Metallic;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-3109.442,-208.2268;Float;False;129;occlusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;843;-3284.641,-741.9624;Float;False;GetMfxAlbedoNormal;31;;45;970bdfdf67ef7df4f8c4f062e76ba030;0;3;32;FLOAT;0;False;18;FLOAT3;0,0,0;False;22;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT3;35
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;873;-3327.523,-447.4196;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-2791.462,-653.0265;Float;False;True;2;Float;MfxShaderGui;0;0;Standard;QFX/MFX/Standard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;True;True;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.1;True;True;2450;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;45;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;405;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;117;1;555;0
WireConnection;28;1;561;0
WireConnection;645;0;117;1
WireConnection;645;1;117;4
WireConnection;126;1;562;0
WireConnection;648;42;28;4
WireConnection;648;33;645;0
WireConnection;648;38;116;0
WireConnection;648;39;118;0
WireConnection;648;40;534;0
WireConnection;128;1;126;1
WireConnection;128;2;127;0
WireConnection;122;0;648;0
WireConnection;121;0;648;30
WireConnection;827;0;27;0
WireConnection;827;1;28;0
WireConnection;129;0;128;0
WireConnection;843;32;876;222
WireConnection;843;22;827;0
WireConnection;873;0;876;201
WireConnection;873;1;28;4
WireConnection;0;0;843;0
WireConnection;0;1;843;35
WireConnection;0;2;876;199
WireConnection;0;3;123;0
WireConnection;0;4;124;0
WireConnection;0;5;130;0
WireConnection;0;10;873;0
ASEEND*/
//CHKSM=E27E83E4FBC6B812A1EC99E78A5475C18EBA513D