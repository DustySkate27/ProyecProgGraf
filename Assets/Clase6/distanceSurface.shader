// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "distanceSurface"
{
	Properties
	{
		_a("a", Vector) = (0,0,0,0)
		_b("b", Vector) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		uniform float3 _a;
		uniform float3 _b;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 temp_cast_0 = (saturate( distance( _a , _b ) )).xxx;
			o.Albedo = temp_cast_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
368;81;1092;526;1349.141;412.3634;1.644282;True;False
Node;AmplifyShaderEditor.CommentaryNode;12;-369.8199,21.05539;Inherit;False;217;185;Escalar (0 a 1);1;10;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;2;-602.5591,41.94777;Inherit;False;Property;_b;b;1;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;1;-603.6263,-133.2878;Inherit;False;Property;_a;a;0;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;11;-365.1908,-184.9649;Inherit;False;216;185;Color;1;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DistanceOpNode;10;-319.8199,71.05539;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;5;-86,17;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-315.1908,-134.9649;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;73,-7;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;distanceSurface;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;1;0
WireConnection;10;1;2;0
WireConnection;5;0;10;0
WireConnection;8;0;1;0
WireConnection;8;1;2;0
WireConnection;0;0;5;0
ASEEND*/
//CHKSM=3FA0A43F3925B0CE27C328F1AC5211CF84BA8ED7