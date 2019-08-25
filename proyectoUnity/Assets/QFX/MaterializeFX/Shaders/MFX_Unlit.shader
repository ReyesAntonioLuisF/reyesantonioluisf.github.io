// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/MFX/Unlit"
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
		_Cutoff( "Mask Clip Value", Float ) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _CUTOFFAXIS_X _CUTOFFAXIS_Y _CUTOFFAXIS_Z
		#pragma shader_feature _MASKTYPE_NONE _MASKTYPE_AXISLOCAL _MASKTYPE_AXISGLOBAL _MASKTYPE_GLOBAL
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _DissolveSize;
		uniform float _UseObjectWorldPosition;
		uniform float3 _MaskWorldPosition;
		uniform float _Invert;
		uniform float _MaskOffset;
		uniform float _DissolveStrength;
		uniform sampler2D _DissolveMap1;
		uniform float2 _DissolveMap1_Scroll;
		uniform float4 _DissolveMap1_ST;
		uniform sampler2D _FlowMap;
		uniform float2 _FlowMap_Scroll;
		uniform float4 _FlowMap_ST;
		uniform float _DistortionStrength;
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
		uniform float _EdgeOffset;
		uniform float _EdgeStrength;
		uniform sampler2D _EdgeMap1;
		uniform float2 _EdgeMap1_Scroll;
		uniform float4 _EdgeMap1_ST;
		uniform float _Emission2Offset;
		uniform float4 _EdgeColor;
		uniform float _EdgeSize;
		uniform float _Cutoff = 0.1;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 transform228_g9 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 temp_cast_2 = (1.0).xxxx;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 temp_cast_6 = (length( ( ase_worldPos - _MaskWorldPosition ) )).xxxx;
			#if defined(_MASKTYPE_NONE)
				float4 staticSwitch10_g9 = temp_cast_2;
			#elif defined(_MASKTYPE_AXISLOCAL)
				float4 staticSwitch10_g9 = float4( ase_vertex3Pos , 0.0 );
			#elif defined(_MASKTYPE_AXISGLOBAL)
				float4 staticSwitch10_g9 = lerp(float4( ase_worldPos , 0.0 ),( float4( ase_worldPos , 0.0 ) - transform228_g9 ),_UseObjectWorldPosition);
			#elif defined(_MASKTYPE_GLOBAL)
				float4 staticSwitch10_g9 = temp_cast_6;
			#else
				float4 staticSwitch10_g9 = lerp(float4( ase_worldPos , 0.0 ),( float4( ase_worldPos , 0.0 ) - transform228_g9 ),_UseObjectWorldPosition);
			#endif
			float4 break13_g9 = staticSwitch10_g9;
			#if defined(_CUTOFFAXIS_X)
				float staticSwitch20_g9 = break13_g9.x;
			#elif defined(_CUTOFFAXIS_Y)
				float staticSwitch20_g9 = break13_g9.y;
			#elif defined(_CUTOFFAXIS_Z)
				float staticSwitch20_g9 = break13_g9.z;
			#else
				float staticSwitch20_g9 = break13_g9.y;
			#endif
			float mfx_pos25_g9 = staticSwitch20_g9;
			float mfx_invert_option23_g9 = lerp(1.0,-1.0,_Invert);
			float temp_output_28_0_g9 = ( mfx_invert_option23_g9 * _MaskOffset );
			float mfx_mask_pos40_g9 = ( ( mfx_pos25_g9 * mfx_invert_option23_g9 ) - temp_output_28_0_g9 );
			float2 uv0_DissolveMap1 = i.uv_texcoord * _DissolveMap1_ST.xy + _DissolveMap1_ST.zw;
			float2 panner83_g9 = ( 1.0 * _Time.y * _DissolveMap1_Scroll + uv0_DissolveMap1);
			float2 uv0_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 panner232_g9 = ( 1.0 * _Time.y * _FlowMap_Scroll + uv0_FlowMap);
			float2 flow_mapa235_g9 = ( (tex2D( _FlowMap, panner232_g9 )).rg * _DistortionStrength );
			float mfx_alpha141_g9 = ( ( ( _DissolveSize + mfx_mask_pos40_g9 ) / _DissolveStrength ) - ( temp_output_28_0_g9 - tex2D( _DissolveMap1, ( panner83_g9 + flow_mapa235_g9 ) ).r ) );
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 uv0_EmissionMap2 = i.uv_texcoord * _EmissionMap2_ST.xy + _EmissionMap2_ST.zw;
			float2 panner22_g9 = ( 1.0 * _Time.y * _EmissionMap2_Scroll + uv0_EmissionMap2);
			float4 tex2DNode29_g9 = tex2D( _EmissionMap2, panner22_g9 );
			float clampResult53_g9 = clamp( ( ( ( 1.0 - tex2DNode29_g9.r ) - 0.5 ) * 3.0 ) , 0.0 , 1.0 );
			float2 uv0_EdgeMap1 = i.uv_texcoord * _EdgeMap1_ST.xy + _EdgeMap1_ST.zw;
			float2 panner27_g9 = ( 1.0 * _Time.y * _EdgeMap1_Scroll + uv0_EdgeMap1);
			float mfx_edge_pos55_g9 = ( 1.0 - ( ( ( _EdgeOffset + mfx_mask_pos40_g9 ) / _EdgeStrength ) - ( temp_output_28_0_g9 - tex2D( _EdgeMap1, ( panner27_g9 + flow_mapa235_g9 ) ).r ) ) );
			float4 mfx_emission_297_g9 = lerp(( _Emission2Color * tex2DNode29_g9.r ),( _Emission2Color * ( lerp(1.0,pow( clampResult53_g9 , 3.0 ),_UseEmission2) * saturate( ( lerp(( 1.0 - mfx_edge_pos55_g9 ),mfx_edge_pos55_g9,_Emission2Invert) + _Emission2Offset ) ) ) ),_Emission2Smooth);
			float temp_output_65_0_g9 = ceil( mfx_edge_pos55_g9 );
			float temp_output_84_0_g9 = saturate( temp_output_65_0_g9 );
			float mfx_edge_threshold108_g9 = temp_output_84_0_g9;
			float4 lerpResult113_g9 = lerp( ( _EmissionColor * tex2D( _EmissionMap, uv_EmissionMap ) ) , mfx_emission_297_g9 , mfx_edge_threshold108_g9);
			float4 mfx_emission129_g9 = lerpResult113_g9;
			float temp_output_66_0_g9 = ( 1.0 - _EdgeSize );
			float smoothstepResult85_g9 = smoothstep( temp_output_66_0_g9 , ( temp_output_66_0_g9 + 0.1 ) , ( 1.0 - abs( mfx_edge_pos55_g9 ) ));
			float mfx_edge119_g9 = saturate( ( smoothstepResult85_g9 - temp_output_84_0_g9 ) );
			float4 mfx_final_emission181_g9 = (( mfx_alpha141_g9 <= _DissolveEdgeSize ) ? _DissolveEdgeColor :  ( mfx_emission129_g9 + ( _EdgeColor * mfx_edge119_g9 ) ) );
			float4 temp_output_850_199 = mfx_final_emission181_g9;
			o.Emission = temp_output_850_199.rgb;
			o.Alpha = 1;
			clip( ( (temp_output_850_199).a * mfx_alpha141_g9 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "MfxShaderGui"
}
/*ASEBEGIN
Version=16700
41;335;1321;406;-636.2901;-322.139;1.557039;True;True
Node;AmplifyShaderEditor.FunctionNode;850;1318.161,614.4644;Float;False;GetMfx;0;;9;fb2280b00bae11444805a18d6fdcad02;0;1;217;COLOR;0,0,0,0;False;3;COLOR;199;FLOAT;201;FLOAT;222
Node;AmplifyShaderEditor.ComponentMaskNode;851;1786.259,736.7936;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;852;1852.259,809.7936;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;831;2104.209,576.1968;Float;False;True;2;Float;MfxShaderGui;0;0;Unlit;QFX/MFX/Unlit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.1;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;31;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;851;0;850;199
WireConnection;852;0;851;0
WireConnection;852;1;850;201
WireConnection;831;2;850;199
WireConnection;831;10;852;0
ASEEND*/
//CHKSM=49C7AD340BC83B57A56AABA42BF96DE5A9E0CB6F