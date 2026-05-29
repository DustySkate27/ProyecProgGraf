// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "epicentro2"
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
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_9_0 = sin( ( ( distance( ase_worldPos , _epicentro ) * _frequency ) + _Time.y ) );
			v.vertex.xyz += ( temp_output_9_0 * float3(0,1,0) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color11 = IsGammaSpace() ? float4(0.1422509,1,0,0) : float4(0.01787474,1,0,0);
			float4 color12 = IsGammaSpace() ? float4(1,0.4489248,0,0) : float4(1,0.1697743,0,0);
			float3 ase_worldPos = i.worldPos;
			float temp_output_9_0 = sin( ( ( distance( ase_worldPos , _epicentro ) * _frequency ) + _Time.y ) );
			float4 lerpResult16 = lerp( color11 , color12 , temp_output_9_0);
			o.Albedo = lerpResult16.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
368;81;1092;526;2240.807;334.5669;2.290717;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;17;-1450.353,26.01411;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;2;-1433.546,220.3122;Inherit;False;Property;_epicentro;epicentro;0;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-1186.34,226.8607;Inherit;False;Property;_frequency;frequency;1;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;3;-1218.18,133.9705;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1068.467,351.2827;Inherit;False;Constant;_speed;speed;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1029.176,133.5444;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;7;-999.7074,248.1434;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-854.0028,140.0928;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;13;-514.8182,452.9622;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;12;-816.8884,-141.4014;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;1,0.4489248,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;9;-731.2178,128.6329;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;-720.2184,-359.4244;Inherit;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;0;False;0;False;0.1422509,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-295.4061,715.0342;Inherit;False;Property;_tess;tess;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-354.7927,68.89373;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-331.4596,398.9368;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;15;-176.4061,614.0342;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;epicentro2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;17;0
WireConnection;3;1;2;0
WireConnection;6;0;3;0
WireConnection;6;1;4;0
WireConnection;7;0;5;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;9;0;8;0
WireConnection;16;0;11;0
WireConnection;16;1;12;0
WireConnection;16;2;9;0
WireConnection;14;0;9;0
WireConnection;14;1;13;0
WireConnection;15;0;10;0
WireConnection;0;0;16;0
WireConnection;0;11;14;0
WireConnection;0;14;15;0
ASEEND*/
//CHKSM=CB9A8BC51DD245796F04246CFF63C99A30E1ADB8