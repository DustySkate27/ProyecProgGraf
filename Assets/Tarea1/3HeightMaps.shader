// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "3HeightMaps"
{
	Properties
	{
		_color("color", 2D) = "white" {}
		_intensity1("intensity1", Float) = 2
		_intensity2("intensity2", Float) = 6
		_intensity3("intensity3", Float) = 0.8
		_clampMinMax("clamp(Min, Max)", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _intensity1;
		uniform float _intensity2;
		uniform float _intensity3;
		uniform float2 _clampMinMax;
		uniform sampler2D _color;
		uniform float4 _color_ST;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.2);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float simplePerlin2D5 = snoise( ( v.texcoord.xy * 2.0 ) );
			simplePerlin2D5 = simplePerlin2D5*0.5 + 0.5;
			float simplePerlin2D23 = snoise( ( v.texcoord.xy * 5.0 ) );
			simplePerlin2D23 = simplePerlin2D23*0.5 + 0.5;
			float simplePerlin2D27 = snoise( ( v.texcoord.xy * 9.0 ) );
			simplePerlin2D27 = simplePerlin2D27*0.5 + 0.5;
			float3 temp_cast_0 = (_clampMinMax.x).xxx;
			float3 temp_cast_1 = (_clampMinMax.y).xxx;
			float3 clampResult40 = clamp( ( ( ( simplePerlin2D5 * _intensity1 ) + ( simplePerlin2D23 * _intensity2 ) + ( simplePerlin2D27 * _intensity3 ) ) * float3(0,1,0) ) , temp_cast_0 , temp_cast_1 );
			v.vertex.xyz += clampResult40;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_color = i.uv_texcoord * _color_ST.xy + _color_ST.zw;
			o.Albedo = tex2D( _color, uv_color ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
341;73;1039;568;1078.644;74.06567;1.350321;False;False
Node;AmplifyShaderEditor.RangedFloatNode;26;-1592.875,778.071;Inherit;False;Constant;_noiseMulti3;noiseMulti3;5;0;Create;True;0;0;0;False;0;False;9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1600.909,503.2251;Inherit;False;Constant;_noiseMulti2;noiseMulti2;4;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1573.192,242.3469;Inherit;False;Constant;_noiseMulti1;noiseMulti1;2;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1653.582,647.9219;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-1637.993,123.4185;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1692.131,367.1936;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1436.394,443.2678;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1428.36,717.1144;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1408.677,181.3902;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1133.369,806.9361;Inherit;False;Property;_intensity3;intensity3;3;0;Create;True;0;0;0;False;0;False;0.8;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1130.655,528.0564;Inherit;False;Property;_intensity2;intensity2;2;0;Create;True;0;0;0;False;0;False;6;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1087.456,278.7561;Inherit;False;Property;_intensity1;intensity1;1;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;27;-1279.409,712.9893;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;23;-1278.023,436.8086;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;5;-1259.494,175.7089;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1024.799,181.4739;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1072.45,716.9517;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1064.238,438.8722;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;4;-737.5331,537.0742;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-843.2487,375.0435;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-665.9376,376.648;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;6;-644.0939,-104.6449;Inherit;True;Property;_color;color;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;41;-418.3368,526.8273;Inherit;False;Property;_clampMinMax;clamp(Min, Max);4;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ClampOpNode;40;-354.215,352.1718;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,10,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;8;-424.0937,-93.60237;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.EdgeLengthTessNode;9;-203.8043,520.3783;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;3HeightMaps;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;31;0
WireConnection;22;1;21;0
WireConnection;25;0;32;0
WireConnection;25;1;26;0
WireConnection;7;0;30;0
WireConnection;7;1;17;0
WireConnection;27;0;25;0
WireConnection;23;0;22;0
WireConnection;5;0;7;0
WireConnection;33;0;5;0
WireConnection;33;1;35;0
WireConnection;37;0;27;0
WireConnection;37;1;38;0
WireConnection;34;0;23;0
WireConnection;34;1;36;0
WireConnection;39;0;33;0
WireConnection;39;1;34;0
WireConnection;39;2;37;0
WireConnection;29;0;39;0
WireConnection;29;1;4;0
WireConnection;40;0;29;0
WireConnection;40;1;41;1
WireConnection;40;2;41;2
WireConnection;8;0;6;0
WireConnection;0;0;8;0
WireConnection;0;11;40;0
WireConnection;0;14;9;0
ASEEND*/
//CHKSM=814FBE2169569288F94C205934A928F5E60DB683