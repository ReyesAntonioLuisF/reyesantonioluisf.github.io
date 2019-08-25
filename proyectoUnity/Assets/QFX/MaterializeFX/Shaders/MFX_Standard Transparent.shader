// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/MFX/Standard Transparent"
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
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma shader_feature _CUTOFFAXIS_X _CUTOFFAXIS_Y _CUTOFFAXIS_Z
		#pragma shader_feature _MASKTYPE_NONE _MASKTYPE_AXISLOCAL _MASKTYPE_AXISGLOBAL _MASKTYPE_GLOBAL
		#pragma shader_feature _METALLICGLOSSMAP_ON
		#pragma shader_feature _SMOOTHNESSTEXTURECHANNEL_METALLICALPHA _SMOOTHNESSTEXTURECHANNEL_ALBEDOALPHA
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
			float4 transform228_g28 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 temp_cast_2 = (1.0).xxxx;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 temp_cast_6 = (length( ( ase_worldPos - _MaskWorldPosition ) )).xxxx;
			#if defined(_MASKTYPE_NONE)
				float4 staticSwitch10_g28 = temp_cast_2;
			#elif defined(_MASKTYPE_AXISLOCAL)
				float4 staticSwitch10_g28 = float4( ase_vertex3Pos , 0.0 );
			#elif defined(_MASKTYPE_AXISGLOBAL)
				float4 staticSwitch10_g28 = lerp(float4( ase_worldPos , 0.0 ),( float4( ase_worldPos , 0.0 ) - transform228_g28 ),_UseObjectWorldPosition);
			#elif defined(_MASKTYPE_GLOBAL)
				float4 staticSwitch10_g28 = temp_cast_6;
			#else
				float4 staticSwitch10_g28 = lerp(float4( ase_worldPos , 0.0 ),( float4( ase_worldPos , 0.0 ) - transform228_g28 ),_UseObjectWorldPosition);
			#endif
			float4 break13_g28 = staticSwitch10_g28;
			#if defined(_CUTOFFAXIS_X)
				float staticSwitch20_g28 = break13_g28.x;
			#elif defined(_CUTOFFAXIS_Y)
				float staticSwitch20_g28 = break13_g28.y;
			#elif defined(_CUTOFFAXIS_Z)
				float staticSwitch20_g28 = break13_g28.z;
			#else
				float staticSwitch20_g28 = break13_g28.y;
			#endif
			float mfx_pos25_g28 = staticSwitch20_g28;
			float mfx_invert_option23_g28 = lerp(1.0,-1.0,_Invert);
			float temp_output_28_0_g28 = ( mfx_invert_option23_g28 * _MaskOffset );
			float mfx_mask_pos40_g28 = ( ( mfx_pos25_g28 * mfx_invert_option23_g28 ) - temp_output_28_0_g28 );
			float2 uv0_EdgeMap1 = i.uv_texcoord * _EdgeMap1_ST.xy + _EdgeMap1_ST.zw;
			float2 panner27_g28 = ( 1.0 * _Time.y * _EdgeMap1_Scroll + uv0_EdgeMap1);
			float2 uv0_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 panner232_g28 = ( 1.0 * _Time.y * _FlowMap_Scroll + uv0_FlowMap);
			float2 flow_mapa235_g28 = ( (tex2D( _FlowMap, panner232_g28 )).rg * _DistortionStrength );
			float mfx_edge_pos55_g28 = ( 1.0 - ( ( ( _EdgeOffset + mfx_mask_pos40_g28 ) / _EdgeStrength ) - ( temp_output_28_0_g28 - tex2D( _EdgeMap1, ( panner27_g28 + flow_mapa235_g28 ) ).r ) ) );
			float temp_output_65_0_g28 = ceil( mfx_edge_pos55_g28 );
			float temp_output_84_0_g28 = saturate( temp_output_65_0_g28 );
			float mfx_edge_threshold108_g28 = temp_output_84_0_g28;
			float temp_output_32_0_g29 = mfx_edge_threshold108_g28;
			float3 lerpResult28_g29 = lerp( UnpackScaleNormal( tex2D( _BumpMap, uv0_BumpMap ), _BumpScale ) , UnpackNormal( tex2D( _BumpMap2, uv2_BumpMap2 ) ) , temp_output_32_0_g29);
			float3 mfx_norma14_g29 = lerpResult28_g29;
			o.Normal = mfx_norma14_g29;
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode28 = tex2D( _MainTex, uv0_MainTex );
			float2 uv_MainTex2 = i.uv_texcoord * _MainTex2_ST.xy + _MainTex2_ST.zw;
			float4 lerpResult9_g29 = lerp( ( _Color * tex2DNode28 ) , ( _Color2 * tex2D( _MainTex2, uv_MainTex2 ) ) , temp_output_32_0_g29);
			float4 myVarName18_g29 = lerpResult9_g29;
			float3 gammaToLinear37_g29 = GammaToLinearSpace( myVarName18_g29.rgb );
			float4 temp_output_835_0 = lerp(myVarName18_g29,float4( gammaToLinear37_g29 , 0.0 ),_GammaToLinear);
			o.Albedo = temp_output_835_0.rgb;
			float2 uv0_DissolveMap1 = i.uv_texcoord * _DissolveMap1_ST.xy + _DissolveMap1_ST.zw;
			float2 panner83_g28 = ( 1.0 * _Time.y * _DissolveMap1_Scroll + uv0_DissolveMap1);
			float mfx_alpha141_g28 = ( ( ( _DissolveSize + mfx_mask_pos40_g28 ) / _DissolveStrength ) - ( temp_output_28_0_g28 - tex2D( _DissolveMap1, ( panner83_g28 + flow_mapa235_g28 ) ).r ) );
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 uv0_EmissionMap2 = i.uv_texcoord * _EmissionMap2_ST.xy + _EmissionMap2_ST.zw;
			float2 panner22_g28 = ( 1.0 * _Time.y * _EmissionMap2_Scroll + uv0_EmissionMap2);
			float4 tex2DNode29_g28 = tex2D( _EmissionMap2, panner22_g28 );
			float clampResult53_g28 = clamp( ( ( ( 1.0 - tex2DNode29_g28.r ) - 0.5 ) * 3.0 ) , 0.0 , 1.0 );
			float4 mfx_emission_297_g28 = lerp(( _Emission2Color * tex2DNode29_g28.r ),( _Emission2Color * ( lerp(1.0,pow( clampResult53_g28 , 3.0 ),_UseEmission2) * saturate( ( lerp(( 1.0 - mfx_edge_pos55_g28 ),mfx_edge_pos55_g28,_Emission2Invert) + _Emission2Offset ) ) ) ),_Emission2Smooth);
			float4 lerpResult113_g28 = lerp( ( _EmissionColor * tex2D( _EmissionMap, uv_EmissionMap ) ) , mfx_emission_297_g28 , mfx_edge_threshold108_g28);
			float4 mfx_emission129_g28 = lerpResult113_g28;
			float temp_output_66_0_g28 = ( 1.0 - _EdgeSize );
			float smoothstepResult85_g28 = smoothstep( temp_output_66_0_g28 , ( temp_output_66_0_g28 + 0.1 ) , ( 1.0 - abs( mfx_edge_pos55_g28 ) ));
			float mfx_edge119_g28 = saturate( ( smoothstepResult85_g28 - temp_output_84_0_g28 ) );
			float4 mfx_final_emission181_g28 = (( mfx_alpha141_g28 <= _DissolveEdgeSize ) ? _DissolveEdgeColor :  ( mfx_emission129_g28 + ( _EdgeColor * mfx_edge119_g28 ) ) );
			o.Emission = mfx_final_emission181_g28.rgb;
			float temp_output_38_0_g30 = _Metallic;
			float2 appendResult19_g30 = (float2(temp_output_38_0_g30 , _Glossiness));
			float temp_output_40_0_g30 = _GlossMapScale;
			float temp_output_42_0_g30 = tex2DNode28.a;
			float2 appendResult23_g30 = (float2(temp_output_38_0_g30 , ( temp_output_40_0_g30 * temp_output_42_0_g30 )));
			#if defined(_SMOOTHNESSTEXTURECHANNEL_METALLICALPHA)
				float staticSwitch45_g30 = 0.0;
			#elif defined(_SMOOTHNESSTEXTURECHANNEL_ALBEDOALPHA)
				float staticSwitch45_g30 = 1.0;
			#else
				float staticSwitch45_g30 = 0.0;
			#endif
			float texturechannel46_g30 = staticSwitch45_g30;
			float2 lerpResult25_g30 = lerp( appendResult19_g30 , appendResult23_g30 , texturechannel46_g30);
			float4 tex2DNode117 = tex2D( _MetallicGlossMap, uv0_MainTex );
			float2 appendResult645 = (float2(tex2DNode117.r , tex2DNode117.a));
			float2 break37_g30 = appendResult645;
			float2 appendResult21_g30 = (float2(break37_g30.x , ( break37_g30.y * temp_output_40_0_g30 )));
			float2 appendResult20_g30 = (float2(break37_g30.x , ( temp_output_42_0_g30 * temp_output_40_0_g30 )));
			float2 lerpResult24_g30 = lerp( appendResult21_g30 , appendResult20_g30 , texturechannel46_g30);
			#ifdef _METALLICGLOSSMAP_ON
				float2 staticSwitch26_g30 = lerpResult24_g30;
			#else
				float2 staticSwitch26_g30 = lerpResult25_g30;
			#endif
			float2 break27_g30 = staticSwitch26_g30;
			float Metallic122 = break27_g30.x;
			o.Metallic = Metallic122;
			float Smothness121 = break27_g30.y;
			o.Smoothness = Smothness121;
			float lerpResult128 = lerp( 1.0 , tex2D( _OcclusionMap, uv0_MainTex ).r , _OcclusionStrength);
			float occlusion129 = lerpResult128;
			o.Occlusion = occlusion129;
			o.Alpha = saturate( ( (temp_output_835_0).a * _Color.a ) );
			clip( mfx_alpha141_g28 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "MfxShaderGui"
}
/*ASEBEGIN
Version=16700
41;335;1321;406;3926.064;-338.8476;1.861608;True;True
Node;AmplifyShaderEditor.CommentaryNode;139;-3320.385,153.1452;Float;False;464.2996;688.226;;4;827;28;27;561;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;561;-3255.246,600.6472;Float;False;0;28;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;115;-3321.184,-521.593;Float;False;1566.448;606.3427;;9;121;122;534;645;116;118;117;555;648;Metallic & Smoothness;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;28;-3277.634,406.1701;Float;True;Property;_MainTex;Albedo;44;0;Create;False;0;0;False;0;None;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;-3258.438,235.4664;Float;False;Property;_Color;Albedo Color;40;1;[HDR];Create;False;0;0;False;0;1,1,1,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;125;-3332.72,955.2072;Float;False;832.5983;527.703;;5;562;129;128;126;127;Ambient Occlusion;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;555;-3241.129,-398.9237;Float;False;0;28;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;827;-3031.418,301.8012;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;836;-2669.162,254.6979;Float;False;GetMfx;0;;28;fb2280b00bae11444805a18d6fdcad02;0;1;217;COLOR;0,0,0,0;False;3;COLOR;199;FLOAT;201;FLOAT;222
Node;AmplifyShaderEditor.TextureCoordinatesNode;562;-3253.253,1045.805;Float;False;0;28;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;117;-2989.493,-422.6545;Float;True;Property;_MetallicGlossMap;Metallic Texture;49;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;116;-2969.59,-213.4382;Float;False;Property;_Metallic;Metallic;48;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;126;-3254.802,1166.305;Float;True;Property;_OcclusionMap;Occlusion;50;0;Create;False;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;835;-2665.262,421.0979;Float;False;GetMfxAlbedoNormal;31;;29;970bdfdf67ef7df4f8c4f062e76ba030;0;3;32;FLOAT;0;False;18;FLOAT3;0,0,0;False;22;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT3;35
Node;AmplifyShaderEditor.DynamicAppendNode;645;-2701.275,-380.7859;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;534;-2967.158,-38.72582;Float;False;Property;_GlossMapScale;Smoothness Scale;46;0;Create;False;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-2970.43,-127.6131;Float;False;Property;_Glossiness;Smoothness;47;0;Create;False;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-3254.802,1374.304;Float;False;Property;_OcclusionStrength;Occlusion;51;0;Create;False;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;648;-2444.452,-242.1904;Float;False;GetMetallicSmoothness;41;;30;6d504252d6074bc4093c6306b92e1b21;0;5;42;FLOAT;0;False;33;FLOAT2;0,0;False;38;FLOAT;0;False;39;FLOAT;0;False;40;FLOAT;0;False;2;FLOAT;0;FLOAT;30
Node;AmplifyShaderEditor.LerpOp;128;-2915.672,1242.707;Float;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;830;-2326.211,550.502;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-2731.573,1239.284;Float;False;occlusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-2026.475,-158.7401;Float;False;Smothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;832;-2254.134,641.662;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-2022.462,-261.4642;Float;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-2194.135,874.4309;Float;False;121;Smothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-2178,958.1201;Float;False;129;occlusion;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;834;-2127.637,643.9897;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-2180.991,793.6592;Float;False;122;Metallic;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1856.499,435.0024;Float;False;True;2;Float;MfxShaderGui;0;0;Standard;QFX/MFX/Standard Transparent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;True;True;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.1;True;True;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;45;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;405;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;1;561;0
WireConnection;827;0;27;0
WireConnection;827;1;28;0
WireConnection;117;1;555;0
WireConnection;126;1;562;0
WireConnection;835;32;836;222
WireConnection;835;22;827;0
WireConnection;645;0;117;1
WireConnection;645;1;117;4
WireConnection;648;42;28;4
WireConnection;648;33;645;0
WireConnection;648;38;116;0
WireConnection;648;39;118;0
WireConnection;648;40;534;0
WireConnection;128;1;126;1
WireConnection;128;2;127;0
WireConnection;830;0;835;0
WireConnection;129;0;128;0
WireConnection;121;0;648;30
WireConnection;832;0;830;0
WireConnection;832;1;27;4
WireConnection;122;0;648;0
WireConnection;834;0;832;0
WireConnection;0;0;835;0
WireConnection;0;1;835;35
WireConnection;0;2;836;199
WireConnection;0;3;123;0
WireConnection;0;4;124;0
WireConnection;0;5;130;0
WireConnection;0;9;834;0
WireConnection;0;10;836;201
ASEEND*/
//CHKSM=D2980D9E17A27B690E455D7EC6BB07C793394170