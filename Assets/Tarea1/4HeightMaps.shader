// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "4HeightMaps"
{
	Properties
	{
		_brickNoiseStrength("brickNoiseStrength", Float) = 0.01
		_stepProportion("stepProportion", Float) = 0.5
		_brickHeight("brickHeight", Float) = 0.18
		_sandColor("sandColor", 2D) = "white" {}
		_clampMinMax("clamp(Min, Max)", Vector) = (0,0,0,0)
		_brickColor("brickColor", 2D) = "white" {}
		_sandNoiseStrength("sandNoiseStrength", Float) = 0.05
		_sandNoiseScale("sandNoiseScale", Float) = 1
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

		uniform float _sandNoiseScale;
		uniform float _sandNoiseStrength;
		uniform float _brickHeight;
		uniform float _brickNoiseStrength;
		uniform float _stepProportion;
		uniform float2 _clampMinMax;
		uniform sampler2D _sandColor;
		uniform float4 _sandColor_ST;
		uniform sampler2D _brickColor;
		uniform float4 _brickColor_ST;


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


		float2 voronoihash23( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi23( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash23( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.2);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float simplePerlin2D72 = snoise( ( v.texcoord.xy * _sandNoiseScale ) );
			simplePerlin2D72 = simplePerlin2D72*0.5 + 0.5;
			float time23 = 0.0;
			float2 coords23 = ( v.texcoord.xy * float2( 12,6 ) ) * 1.0;
			float2 id23 = 0;
			float2 uv23 = 0;
			float voroi23 = voronoi23( coords23, time23, id23, uv23, 0 );
			float simplePerlin2D28 = snoise( ( v.texcoord.xy * float2( 12,8 ) ) );
			simplePerlin2D28 = simplePerlin2D28*0.5 + 0.5;
			float temp_output_29_0 = step( ( voroi23 + ( simplePerlin2D28 * _brickNoiseStrength ) ) , _stepProportion );
			float lerpResult51 = lerp( ( simplePerlin2D72 * _sandNoiseStrength ) , _brickHeight , temp_output_29_0);
			float3 temp_cast_0 = (_clampMinMax.x).xxx;
			float3 temp_cast_1 = (_clampMinMax.y).xxx;
			float3 clampResult59 = clamp( ( lerpResult51 * float3(0,1,0) ) , temp_cast_0 , temp_cast_1 );
			v.vertex.xyz += clampResult59;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_sandColor = i.uv_texcoord * _sandColor_ST.xy + _sandColor_ST.zw;
			float2 uv_brickColor = i.uv_texcoord * _brickColor_ST.xy + _brickColor_ST.zw;
			float time23 = 0.0;
			float2 coords23 = ( i.uv_texcoord * float2( 12,6 ) ) * 1.0;
			float2 id23 = 0;
			float2 uv23 = 0;
			float voroi23 = voronoi23( coords23, time23, id23, uv23, 0 );
			float simplePerlin2D28 = snoise( ( i.uv_texcoord * float2( 12,8 ) ) );
			simplePerlin2D28 = simplePerlin2D28*0.5 + 0.5;
			float temp_output_29_0 = step( ( voroi23 + ( simplePerlin2D28 * _brickNoiseStrength ) ) , _stepProportion );
			float4 lerpResult45 = lerp( tex2D( _sandColor, uv_sandColor ) , tex2D( _brickColor, uv_brickColor ) , temp_output_29_0);
			o.Albedo = lerpResult45.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
341;73;1039;568;2080.069;62.72956;1.300648;False;False
Node;AmplifyShaderEditor.CommentaryNode;78;-2017.848,477.2635;Inherit;False;905.1664;372.7496;Brick Map with Noise;6;26;76;24;33;28;32;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;76;-1882.434,686.0131;Inherit;False;Constant;_brickGridSize;brickGridSize;7;0;Create;True;0;0;0;False;0;False;12,8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;77;-2127.527,7.604763;Inherit;False;808.7963;369.1536;sandGrid;4;22;20;21;23;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1967.848,527.2635;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;22;-1969.641,212.7584;Inherit;False;Constant;_sandGridSize;sandGridSize;1;0;Create;True;0;0;0;False;0;False;12,6;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1634.05,619.4352;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-2077.527,57.60476;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1475.553,710.1262;Inherit;False;Property;_brickNoiseStrength;brickNoiseStrength;0;0;Create;True;0;0;0;False;0;False;0.01;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1775.129,186.8857;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;28;-1493.21,612.0181;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1072.159,740.436;Inherit;False;939.6836;318.6442;Sand Grid Heigth with Noise;6;69;71;70;72;74;73;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VoronoiNode;23;-1518.73,199.0999;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1274.681,608.7319;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-1022.159,790.436;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-905.633,943.0802;Inherit;False;Property;_sandNoiseScale;sandNoiseScale;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-711.4195,839.5004;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1053.948,373.7141;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-924.9203,567.8246;Inherit;False;Property;_stepProportion;stepProportion;1;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;29;-862.6923,425.0951;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;72;-560.1134,832.1537;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-567.4752,932.7639;Inherit;False;Property;_sandNoiseStrength;sandNoiseStrength;6;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-430.3296,560.3412;Inherit;False;Property;_brickHeight;brickHeight;2;0;Create;True;0;0;0;False;0;False;0.18;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;80;-246.4136,327.0646;Inherit;False;579.3102;405.1364;Height Clamp;5;55;51;54;59;81;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-294.4754,864.2685;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;53;-301.7563,490.8622;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;51;-196.4136,377.0646;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;61;-963.5559,-37.23563;Inherit;True;Property;_brickColor;brickColor;5;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WireNode;57;-442.1234,474.313;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;60;-906.5559,-249.2356;Inherit;True;Property;_sandColor;sandColor;3;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector3Node;55;-153.0552,544.201;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-9.777737,378.6938;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;62;-583.5559,-234.2356;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;56;-431.5966,191.8953;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;63;-684.2612,-15.16052;Inherit;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;81;61.97748,552.3589;Inherit;False;Property;_clampMinMax;clamp(Min, Max);4;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ClampOpNode;59;161.8966,378.4281;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,3,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;45;-269.3572,4.501907;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;58;417.3352,559.4462;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;344.6875,-4.264721;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;4HeightMaps;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;26;0
WireConnection;24;1;76;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;28;0;24;0
WireConnection;23;0;21;0
WireConnection;32;0;28;0
WireConnection;32;1;33;0
WireConnection;70;0;69;0
WireConnection;70;1;71;0
WireConnection;30;0;23;0
WireConnection;30;1;32;0
WireConnection;29;0;30;0
WireConnection;29;1;31;0
WireConnection;72;0;70;0
WireConnection;73;0;72;0
WireConnection;73;1;74;0
WireConnection;53;0;29;0
WireConnection;51;0;73;0
WireConnection;51;1;49;0
WireConnection;51;2;53;0
WireConnection;57;0;29;0
WireConnection;54;0;51;0
WireConnection;54;1;55;0
WireConnection;62;0;60;0
WireConnection;56;0;57;0
WireConnection;63;0;61;0
WireConnection;59;0;54;0
WireConnection;59;1;81;1
WireConnection;59;2;81;2
WireConnection;45;0;62;0
WireConnection;45;1;63;0
WireConnection;45;2;56;0
WireConnection;0;0;45;0
WireConnection;0;11;59;0
WireConnection;0;14;58;0
ASEEND*/
//CHKSM=451353ED87D289285DCFFE4CBE85E935DD3FD012