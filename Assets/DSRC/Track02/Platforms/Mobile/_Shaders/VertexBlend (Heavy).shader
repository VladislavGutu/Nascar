// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Arkhhams/Mobile/VertexBlend (Heavy)"
{
	Properties
	{
		_v("v", Float) = 0.5
		_AlbedoR("Albedo (R)", 2D) = "white" {}
		_NormalR("Normal (R)", 2D) = "bump" {}
		_SGR("SG (R)", 2D) = "white" {}
		_AlbedoG("Albedo (G)", 2D) = "white" {}
		_NormalG("Normal (G)", 2D) = "bump" {}
		_SGG("SG (G)", 2D) = "white" {}
		_AlbedoB("Albedo (B)", 2D) = "white" {}
		_NormalB("Normal (B)", 2D) = "bump" {}
		_SGB("SG (B)", 2D) = "white" {}
		_AlbedoA("Albedo (A)", 2D) = "white" {}
		_NormalA("Normal (A)", 2D) = "bump" {}
		_AlphaSG("Alpha SG", Float) = 0.01
		_Cubemap1("Cubemap", CUBE) = "white" {}
		_CubemapValue("Cubemap Value", 2D) = "white" {}
		_Intensity("Intensity", Float) = 0
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

		UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalA);
		uniform half4 _NormalA_ST;
		SamplerState sampler_NormalA;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalR);
		uniform half4 _NormalR_ST;
		SamplerState sampler_NormalR;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalG);
		uniform half4 _NormalG_ST;
		SamplerState sampler_NormalG;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_NormalB);
		uniform half4 _NormalB_ST;
		SamplerState sampler_NormalB;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_AlbedoA);
		uniform half4 _AlbedoA_ST;
		SamplerState sampler_AlbedoA;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_AlbedoR);
		uniform half4 _AlbedoR_ST;
		SamplerState sampler_AlbedoR;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_AlbedoG);
		uniform half4 _AlbedoG_ST;
		SamplerState sampler_AlbedoG;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_AlbedoB);
		uniform half4 _AlbedoB_ST;
		SamplerState sampler_AlbedoB;
		uniform half _Intensity;
		uniform float _v;
		UNITY_DECLARE_TEXCUBE_NOSAMPLER(_Cubemap1);
		SamplerState sampler_Cubemap1;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_CubemapValue);
		uniform half4 _CubemapValue_ST;
		SamplerState sampler_CubemapValue;
		uniform half _AlphaSG;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SGR);
		SamplerState sampler_SGR;
		uniform half4 _SGR_ST;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SGG);
		SamplerState sampler_SGG;
		uniform half4 _SGG_ST;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_SGB);
		SamplerState sampler_SGB;
		uniform half4 _SGB_ST;

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_NormalA = i.uv_texcoord * _NormalA_ST.xy + _NormalA_ST.zw;
			float2 uv_NormalR = i.uv_texcoord * _NormalR_ST.xy + _NormalR_ST.zw;
			float2 uv_NormalG = i.uv_texcoord * _NormalG_ST.xy + _NormalG_ST.zw;
			half3 lerpResult20 = lerp( UnpackNormal( SAMPLE_TEXTURE2D( _NormalR, sampler_NormalR, uv_NormalR ) ) , UnpackNormal( SAMPLE_TEXTURE2D( _NormalG, sampler_NormalG, uv_NormalG ) ) , i.vertexColor.g);
			float2 uv_NormalB = i.uv_texcoord * _NormalB_ST.xy + _NormalB_ST.zw;
			half3 lerpResult19 = lerp( lerpResult20 , UnpackNormal( SAMPLE_TEXTURE2D( _NormalB, sampler_NormalB, uv_NormalB ) ) , i.vertexColor.b);
			half3 lerpResult21 = lerp( UnpackNormal( SAMPLE_TEXTURE2D( _NormalA, sampler_NormalA, uv_NormalA ) ) , lerpResult19 , i.vertexColor.a);
			o.Normal = lerpResult21;
			float2 uv_AlbedoA = i.uv_texcoord * _AlbedoA_ST.xy + _AlbedoA_ST.zw;
			float2 uv_AlbedoR = i.uv_texcoord * _AlbedoR_ST.xy + _AlbedoR_ST.zw;
			float2 uv_AlbedoG = i.uv_texcoord * _AlbedoG_ST.xy + _AlbedoG_ST.zw;
			half4 lerpResult5 = lerp( SAMPLE_TEXTURE2D( _AlbedoR, sampler_AlbedoR, uv_AlbedoR ) , SAMPLE_TEXTURE2D( _AlbedoG, sampler_AlbedoG, uv_AlbedoG ) , i.vertexColor.g);
			float2 uv_AlbedoB = i.uv_texcoord * _AlbedoB_ST.xy + _AlbedoB_ST.zw;
			half4 lerpResult6 = lerp( lerpResult5 , SAMPLE_TEXTURE2D( _AlbedoB, sampler_AlbedoB, uv_AlbedoB ) , i.vertexColor.b);
			half4 lerpResult7 = lerp( SAMPLE_TEXTURE2D( _AlbedoA, sampler_AlbedoA, uv_AlbedoA ) , lerpResult6 , i.vertexColor.a);
			o.Albedo = lerpResult7.rgb;
			half3 ase_worldReflection = WorldReflectionVector( i, half3( 0, 0, 1 ) );
			float2 uv_CubemapValue = i.uv_texcoord * _CubemapValue_ST.xy + _CubemapValue_ST.zw;
			half4 lerpResult67 = lerp( float4( 0,0,0,0 ) , SAMPLE_TEXTURE2D( _CubemapValue, sampler_CubemapValue, uv_CubemapValue ) , i.vertexColor.b);
			o.Emission = ( _Intensity * ( ( ( 1.0 - _v ) * SAMPLE_TEXTURECUBE( _Cubemap1, sampler_Cubemap1, ase_worldReflection ) ) * lerpResult67 ) ).rgb;
			float2 uv_SGR = i.uv_texcoord * _SGR_ST.xy + _SGR_ST.zw;
			half4 tex2DNode34 = SAMPLE_TEXTURE2D( _SGR, sampler_SGR, uv_SGR );
			float2 uv_SGG = i.uv_texcoord * _SGG_ST.xy + _SGG_ST.zw;
			half4 tex2DNode35 = SAMPLE_TEXTURE2D( _SGG, sampler_SGG, uv_SGG );
			half lerpResult39 = lerp( tex2DNode34.r , tex2DNode35.r , i.vertexColor.g);
			float2 uv_SGB = i.uv_texcoord * _SGB_ST.xy + _SGB_ST.zw;
			half4 tex2DNode38 = SAMPLE_TEXTURE2D( _SGB, sampler_SGB, uv_SGB );
			half lerpResult42 = lerp( lerpResult39 , tex2DNode38.r , i.vertexColor.b);
			half lerpResult45 = lerp( _AlphaSG , lerpResult42 , i.vertexColor.a);
			o.Specular = lerpResult45;
			half lerpResult46 = lerp( tex2DNode34.g , tex2DNode35.g , i.vertexColor.g);
			half lerpResult47 = lerp( lerpResult46 , tex2DNode38.g , i.vertexColor.b);
			half lerpResult48 = lerp( _AlphaSG , lerpResult47 , i.vertexColor.a);
			o.Gloss = lerpResult48;
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
0;42;1920;1017;1834.43;-1211.449;1;True;False
Node;AmplifyShaderEditor.VertexColorNode;8;-1916.367,156.965;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;32;-2645.512,1906.692;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldReflectionVector;60;-731.9071,1952.781;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;33;-2182.45,1819.776;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;11;-1453.305,70.04895;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-682.693,1840.963;Float;False;Property;_v;v;0;0;Create;True;0;0;False;0;False;0.5;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-2114.531,1426.093;Inherit;True;Property;_SGR;SG (R);3;0;Create;True;0;0;False;0;False;-1;None;57769297c29201e42a2f1d6a97add1d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;37;-2191.805,2017.781;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;36;-1764.612,1793.271;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;58;-373.7562,1879.38;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;13;-1462.66,268.0544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-1358.254,748.0374;Inherit;True;Property;_NormalG;Normal (G);5;0;Create;True;0;0;False;0;False;-1;None;40dd8e919b5b7fa4ebc1806d4241c435;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1385.387,-117.2812;Inherit;True;Property;_AlbedoG;Albedo (G);4;0;Create;True;0;0;False;0;False;-1;None;6b70e5099a8f8bf49a51a9db8c30d13d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1385.386,-323.6333;Inherit;True;Property;_AlbedoR;Albedo (R);1;0;Create;True;0;0;False;0;False;-1;None;6a82ed3d9cb39d34ba8e01094f074497;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;-464.2075,1973.581;Inherit;True;Property;_Cubemap1;Cubemap;13;0;Create;True;0;0;False;0;False;-1;None;2ca47c8eae849454c8aa5f386075f650;True;0;False;white;Auto;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;9;-1035.467,43.5443;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-1358.253,541.6853;Inherit;True;Property;_NormalR;Normal (R);2;0;Create;True;0;0;False;0;False;-1;None;4f4b03d3bf52faf49b2a24f5590a7e3d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;66;-1330.851,2335.364;Inherit;True;Property;_CubemapValue;Cubemap Value;14;0;Create;True;0;0;False;0;False;-1;None;7f38ac94d54a240479b8ba9634da7d8e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-2114.532,1632.445;Inherit;True;Property;_SGG;SG (G);6;0;Create;True;0;0;False;0;False;-1;None;41c13ea0091988042b7072be175be9fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;5;-957.3453,-189.7833;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;67;-766.1133,2220.433;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;10;-952.8354,238.4315;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;41;-2185.568,2217.345;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-1355.466,955.7837;Inherit;True;Property;_NormalB;Normal (B);8;0;Create;True;0;0;False;0;False;-1;None;67f946c1c18b8fe47a77e545585b917a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;20;-930.2123,675.5353;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;3;-1382.599,90.46506;Inherit;True;Property;_AlbedoB;Albedo (B);7;0;Create;True;0;0;False;0;False;-1;None;256c6dda619ebf14692442bf2d239597;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;46;-1359.389,1460.546;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;38;-2111.744,1840.192;Inherit;True;Property;_SGB;SG (B);9;0;Create;True;0;0;False;0;False;-1;None;b2eb684cce185c940a07cdf4e88eb55a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;39;-1683.491,1544.405;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;14;-1456.423,467.6188;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-137.7833,1881.578;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;40;-1681.981,1988.158;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-672.2888,1657.872;Inherit;False;Property;_AlphaSG;Alpha SG;12;0;Create;True;0;0;False;0;False;0.01;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-802.5816,9.597442;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;-1381.204,298.2116;Inherit;True;Property;_AlbedoA;Albedo (A);10;0;Create;True;0;0;False;0;False;-1;None;b567536e3bdf8054783e2f74c99a1037;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;12;-896.7082,425.5238;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;42;-1519.156,1731.389;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;-1114.831,1768.975;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;139.2257,1897.894;Inherit;False;Property;_Intensity;Intensity;15;0;Create;True;0;0;False;0;False;0;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;44;-1625.854,2175.25;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-1354.071,1163.53;Inherit;True;Property;_NormalA;Normal (A);11;0;Create;True;0;0;False;0;False;-1;None;3e6017eb9813574479d50e287198729d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;58.15618,2124.08;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;19;-775.4487,874.916;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;21;-566.3082,1035.257;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;45;627.3577,340.7164;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;-510.4411,110.9386;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;742.9661,999.3395;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;48;631.9734,527.6584;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1030.639,252.8405;Half;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;Arkhhams/Mobile/VertexBlend (Heavy);False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;33;0;32;2
WireConnection;11;0;8;2
WireConnection;37;0;32;3
WireConnection;36;0;33;0
WireConnection;58;0;61;0
WireConnection;13;0;8;3
WireConnection;59;1;60;0
WireConnection;9;0;11;0
WireConnection;5;0;1;0
WireConnection;5;1;2;0
WireConnection;5;2;9;0
WireConnection;67;1;66;0
WireConnection;67;2;32;3
WireConnection;10;0;13;0
WireConnection;41;0;32;4
WireConnection;20;0;16;0
WireConnection;20;1;15;0
WireConnection;20;2;8;2
WireConnection;46;0;34;2
WireConnection;46;1;35;2
WireConnection;46;2;32;2
WireConnection;39;0;34;1
WireConnection;39;1;35;1
WireConnection;39;2;36;0
WireConnection;14;0;8;4
WireConnection;57;0;58;0
WireConnection;57;1;59;0
WireConnection;40;0;37;0
WireConnection;6;0;5;0
WireConnection;6;1;3;0
WireConnection;6;2;10;0
WireConnection;12;0;14;0
WireConnection;42;0;39;0
WireConnection;42;1;38;1
WireConnection;42;2;40;0
WireConnection;47;0;46;0
WireConnection;47;1;38;2
WireConnection;47;2;32;3
WireConnection;44;0;41;0
WireConnection;55;0;57;0
WireConnection;55;1;67;0
WireConnection;19;0;20;0
WireConnection;19;1;17;0
WireConnection;19;2;8;3
WireConnection;21;0;18;0
WireConnection;21;1;19;0
WireConnection;21;2;8;4
WireConnection;45;0;52;0
WireConnection;45;1;42;0
WireConnection;45;2;44;0
WireConnection;7;0;4;0
WireConnection;7;1;6;0
WireConnection;7;2;12;0
WireConnection;54;0;56;0
WireConnection;54;1;55;0
WireConnection;48;0;52;0
WireConnection;48;1;47;0
WireConnection;48;2;32;4
WireConnection;0;0;7;0
WireConnection;0;1;21;0
WireConnection;0;2;54;0
WireConnection;0;3;45;0
WireConnection;0;4;48;0
ASEEND*/
//CHKSM=C127F1233F15835E60D9A1DC9745F252BD5ACE70