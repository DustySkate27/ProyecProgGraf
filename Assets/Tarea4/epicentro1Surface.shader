// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "epicentro1Surface"
{
	Properties
	{
		_epicentro("epicentro", Vector) = (0,0,1,0)
		_frequency("frequency", Float) = 10
		_tess("tess", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
		};

		uniform float3 _epicentro;
		uniform float _frequency;
		uniform float _tess;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _tess);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_41_0 = sin( ( ( distance( ase_vertex3Pos , _epicentro ) * _frequency ) + _Time.y ) );
			v.vertex.xyz += ( temp_output_41_0 * float3(0,1,0) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color50 = IsGammaSpace() ? float4(0.1422509,1,0,0) : float4(0.01787474,1,0,0);
			float4 color49 = IsGammaSpace() ? float4(1,0.4489248,0,0) : float4(1,0.1697743,0,0);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_41_0 = sin( ( ( distance( ase_vertex3Pos , _epicentro ) * _frequency ) + _Time.y ) );
			float4 lerpResult47 = lerp( color50 , color49 , temp_output_41_0);
			o.Albedo = lerpResult47.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
368;81;1092;526;2155.396;524.699;2.845514;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;31;-1066.375,-22.87014;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;33;-1058.189,137.5685;Inherit;False;Property;_epicentro;epicentro;0;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;34;-842.8224,51.22677;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-810.9827,144.117;Inherit;False;Property;_frequency;frequency;1;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-693.1091,268.539;Inherit;False;Constant;_speed;speed;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-653.8184,50.80066;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;38;-624.3497,165.3997;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-478.6451,57.34914;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;44;-139.4605,370.2184;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;49;-441.5307,-224.145;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;1,0.4489248,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;41;-355.8601,45.88924;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;79.95163,632.2906;Inherit;False;Property;_tess;tess;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;50;-344.8607,-442.1682;Inherit;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;0;False;0;False;0.1422509,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.EdgeLengthTessNode;45;198.9516,531.2906;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;43.89807,316.193;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;47;20.56503,-13.84998;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;576.0001,23.34856;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;epicentro1Surface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;31;0
WireConnection;34;1;33;0
WireConnection;35;0;34;0
WireConnection;35;1;36;0
WireConnection;38;0;39;0
WireConnection;37;0;35;0
WireConnection;37;1;38;0
WireConnection;41;0;37;0
WireConnection;45;0;46;0
WireConnection;43;0;41;0
WireConnection;43;1;44;0
WireConnection;47;0;50;0
WireConnection;47;1;49;0
WireConnection;47;2;41;0
WireConnection;0;0;47;0
WireConnection;0;11;43;0
WireConnection;0;14;45;0
ASEEND*/
//CHKSM=30DE17DC3FAF3D487E5D61A30F6207C5B479488D