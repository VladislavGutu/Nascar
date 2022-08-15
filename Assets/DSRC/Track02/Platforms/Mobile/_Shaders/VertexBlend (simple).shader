// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Arkhhams/Mobile/VertexBlend (Simple)"
{
	Properties
	{
		_Intensity("Intensity", Float) = 0
		_BaseR("Base (R)", 2D) = "white" {}
		_BaseG("Base (G)", 2D) = "white" {}
		_BaseB("Base (B)", 2D) = "white" {}
		_BaseA("Base (A)", 2D) = "white" {}
		_Cubemap1("Cubemap", CUBE) = "white" {}
		_CubeMapValue("CubeMap Value", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#define SAMPLE_TEXTURECUBE(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#define SAMPLE_TEXTURECUBE(tex,samplertex,coord) texCUBE(tex,coord)
		#endif//ASE Sampling Macros

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			half3 worldRefl;
			INTERNAL_DATA
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseA);
		uniform half4 _BaseA_ST;
		SamplerState sampler_BaseA;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseR);
		uniform half4 _BaseR_ST;
		SamplerState sampler_BaseR;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseG);
		uniform half4 _BaseG_ST;
		SamplerState sampler_BaseG;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BaseB);
		uniform half4 _BaseB_ST;
		SamplerState sampler_BaseB;
		uniform half _Intensity;
		UNITY_DECLARE_TEXCUBE_NOSAMPLER(_Cubemap1);
		SamplerState sampler_Cubemap1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CubeMapValue);
		uniform half4 _CubeMapValue_ST;
		SamplerState sampler_CubeMapValue;

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_BaseA = i.uv_texcoord * _BaseA_ST.xy + _BaseA_ST.zw;
			float2 uv_BaseR = i.uv_texcoord * _BaseR_ST.xy + _BaseR_ST.zw;
			float2 uv_BaseG = i.uv_texcoord * _BaseG_ST.xy + _BaseG_ST.zw;
			half4 lerpResult5 = lerp( SAMPLE_TEXTURE2D( _BaseR, sampler_BaseR, uv_BaseR ) , SAMPLE_TEXTURE2D( _BaseG, sampler_BaseG, uv_BaseG ) , i.vertexColor.g);
			float2 uv_BaseB = i.uv_texcoord * _BaseB_ST.xy + _BaseB_ST.zw;
			half4 lerpResult6 = lerp( lerpResult5 , SAMPLE_TEXTURE2D( _BaseB, sampler_BaseB, uv_BaseB ) , i.vertexColor.b);
			half4 lerpResult7 = lerp( SAMPLE_TEXTURE2D( _BaseA, sampler_BaseA, uv_BaseA ) , lerpResult6 , i.vertexColor.a);
			o.Albedo = lerpResult7.rgb;
			half3 ase_worldReflection = i.worldRefl;
			float2 uv_CubeMapValue = i.uv_texcoord * _CubeMapValue_ST.xy + _CubeMapValue_ST.zw;
			half4 lerpResult67 = lerp( float4( 0,0,0,0 ) , SAMPLE_TEXTURE2D( _CubeMapValue, sampler_CubeMapValue, uv_CubeMapValue ) , i.vertexColor.b);
			o.Emission = ( _Intensity * ( ( ( 1.0 - 0.3 ) * SAMPLE_TEXTURECUBE( _Cubemap1, sampler_Cubemap1, ase_worldReflection ) ) * lerpResult67 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Lambert keepalpha fullforwardshadows 

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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
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
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	
}
/*ASEBEGIN
Version=18401
2051;98;1462;706;1033.705;-671.04;1;True;False
Node;AmplifyShaderEditor.VertexColorNode;8;-1252.448,469.099;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldReflectionVector;60;-403.8763,1112.878;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;61;-349.6622,1013.06;Float;False;Constant;_v;v;0;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;11;-815.2669,322.3804;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;9;-274.8679,295.8756;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;13;-824.6219,520.386;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;58;-45.7254,1039.477;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-136.1767,1133.678;Inherit;True;Property;_Cubemap1;Cubemap;5;0;Create;True;0;0;False;0;False;-1;None;2ca47c8eae849454c8aa5f386075f650;True;0;False;white;Auto;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;66;-785.2096,1386.376;Inherit;True;Property;_CubeMapValue;CubeMap Value;6;0;Create;True;0;0;False;0;False;-1;3b23e754bebe2904f92fff0b2f2f3855;3b23e754bebe2904f92fff0b2f2f3855;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-624.7866,-71.3019;Inherit;True;Property;_BaseR;Base (R);1;0;Create;True;0;0;False;0;False;-1;None;027cd12f218401747bd334a376c78cbc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-624.7876,135.0502;Inherit;True;Property;_BaseG;Base (G);2;0;Create;True;0;0;False;0;False;-1;None;f867eb539a822c943800e4f821c32415;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-621.9996,342.7964;Inherit;True;Property;_BaseB;Base (B);3;0;Create;True;0;0;False;0;False;-1;None;9ffb0ebacb559634799f1376542ca681;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;10;-192.2364,490.7628;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;67;-438.0825,1380.53;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;5;-196.7463,62.5481;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;14;-818.3848,719.9503;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;190.2475,1041.675;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;467.2565,1057.991;Inherit;False;Property;_Intensity;Intensity;0;0;Create;True;0;0;False;0;False;0;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-620.6046,550.543;Inherit;True;Property;_BaseA;Base (A);4;0;Create;True;0;0;False;0;False;-1;None;7a257044bd716dc45a21d46f66a908cb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;6;-41.98263,261.9288;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;12;-136.1092,677.8551;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;386.187,1284.177;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;742.9661,999.3395;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;7;250.1578,363.2699;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1028.177,555.7102;Half;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;Arkhhams/Mobile/VertexBlend (Simple);False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;8;2
WireConnection;9;0;11;0
WireConnection;13;0;8;3
WireConnection;58;0;61;0
WireConnection;59;1;60;0
WireConnection;10;0;13;0
WireConnection;67;1;66;0
WireConnection;67;2;8;3
WireConnection;5;0;1;0
WireConnection;5;1;2;0
WireConnection;5;2;9;0
WireConnection;14;0;8;4
WireConnection;57;0;58;0
WireConnection;57;1;59;0
WireConnection;6;0;5;0
WireConnection;6;1;3;0
WireConnection;6;2;10;0
WireConnection;12;0;14;0
WireConnection;55;0;57;0
WireConnection;55;1;67;0
WireConnection;54;0;56;0
WireConnection;54;1;55;0
WireConnection;7;0;4;0
WireConnection;7;1;6;0
WireConnection;7;2;12;0
WireConnection;0;0;7;0
WireConnection;0;2;54;0
ASEEND*/
//CHKSM=16E6719392EFC150E75F047F012977E9301A18A9