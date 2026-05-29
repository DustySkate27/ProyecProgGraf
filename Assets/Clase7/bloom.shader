// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "bloom"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_TextureSample1("Texture Sample 0", 2D) = "white" {}
		_promedio2("promedio", Float) = 4
		_blur("blur", Vector) = (0,0,0,0)
		_TextureSample2("Texture Sample 1", 2D) = "white" {}
		_TextureSample3("Texture Sample 2", 2D) = "white" {}
		_TextureSample4("Texture Sample 3", 2D) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _TextureSample1;
			uniform float2 _blur;
			uniform sampler2D _TextureSample2;
			uniform sampler2D _TextureSample3;
			uniform sampler2D _TextureSample4;
			uniform float _promedio2;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 texCoord19 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_cast_0 = (( texCoord19.x + _blur.x )).xx;
				float2 temp_cast_1 = (( texCoord19.x - _blur.x )).xx;
				float2 temp_cast_2 = (( texCoord19.y + _blur.y )).xx;
				float2 temp_cast_3 = (( texCoord19.y - _blur.y )).xx;
				

				finalColor = ( ( tex2D( _TextureSample1, temp_cast_0 ) + tex2D( _TextureSample2, temp_cast_1 ) + tex2D( _TextureSample3, temp_cast_2 ) + tex2D( _TextureSample4, temp_cast_3 ) ) / _promedio2 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;73;1920;920;1536.49;31.68301;1.3;False;False
Node;AmplifyShaderEditor.CommentaryNode;32;-923.2091,117.4542;Inherit;False;1379.912;954.7412;Blur;13;19;37;34;22;35;23;31;29;30;28;27;26;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-864.1591,413.0241;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;37;-739.7396,650.1445;Inherit;False;Property;_blur;blur;5;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-480.4097,458.9441;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-481.6027,848.1501;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-477.3331,635.7947;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-471.8162,297.6194;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;-237.3816,420.2035;Inherit;True;Property;_TextureSample2;Texture Sample 1;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-231.7239,819.8113;Inherit;True;Property;_TextureSample4;Texture Sample 3;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-239.3475,618.0258;Inherit;True;Property;_TextureSample3;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-249.6348,232.6136;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;30;108.4709,478.0475;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;299.1828,589.9393;Inherit;False;Property;_promedio2;promedio;4;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;33;-819.4638,-463.1258;Inherit;False;1319.834;560.3316;Bloom mask;8;21;9;6;7;8;5;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;183.1563,-242.8703;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-272.0261,-8.330402;Inherit;False;Property;_max;max;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;5;-300.0839,-231.862;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;318.8704,488.9057;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;3;-681.6746,-127.3384;Inherit;False;Property;_bloom;bloom;0;0;Create;True;0;0;0;False;0;False;0.07,0.03,0.05;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;2;-631.6907,-397.4297;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;21;-777.8962,-398.7177;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;6;-128.6896,-220.2585;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-322.4083,-114.3075;Inherit;False;Property;_min;min;2;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;664.3486,59.11208;Float;False;True;-1;2;ASEMaterialInspector;0;2;bloom;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;23;0;19;1
WireConnection;23;1;37;1
WireConnection;22;0;19;2
WireConnection;22;1;37;2
WireConnection;35;0;19;2
WireConnection;35;1;37;2
WireConnection;34;0;19;1
WireConnection;34;1;37;1
WireConnection;27;1;23;0
WireConnection;25;1;22;0
WireConnection;26;1;35;0
WireConnection;28;1;34;0
WireConnection;30;0;28;0
WireConnection;30;1;27;0
WireConnection;30;2;26;0
WireConnection;30;3;25;0
WireConnection;9;0;2;0
WireConnection;9;1;6;0
WireConnection;5;0;2;0
WireConnection;5;1;3;0
WireConnection;31;0;30;0
WireConnection;31;1;29;0
WireConnection;2;0;21;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;6;2;8;0
WireConnection;0;0;31;0
ASEEND*/
//CHKSM=E42098C03929E2109580C0F9A76F7267EB178B6C