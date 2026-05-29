// Upgrade NOTE: upgraded instancing buffer 'motionBlur' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "motionBlur"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_blur1("blur1", Vector) = (0,0,0,0)
		_blur2("blur2", Float) = 2
		_blur3("blur3", Float) = 3
		_blur4("blur4", Float) = 4
		_promedio1("promedio", Float) = 4

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
			#pragma multi_compile_instancing


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
			
			uniform float _blur2;
			uniform float _blur3;
			uniform float _blur4;
			uniform float _promedio1;
			UNITY_INSTANCING_BUFFER_START(motionBlur)
				UNITY_DEFINE_INSTANCED_PROP(float2, _blur1)
#define _blur1_arr motionBlur
			UNITY_INSTANCING_BUFFER_END(motionBlur)


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
				float2 texCoord1 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 _blur1_Instance = UNITY_ACCESS_INSTANCED_PROP(_blur1_arr, _blur1);
				

				finalColor = ( ( tex2D( _MainTex, ( texCoord1 - _blur1_Instance ) ) + tex2D( _MainTex, ( texCoord1 - ( _blur1_Instance * _blur2 ) ) ) + tex2D( _MainTex, ( texCoord1 - ( _blur1_Instance * _blur3 ) ) ) + tex2D( _MainTex, ( texCoord1 - ( _blur1_Instance * _blur4 ) ) ) ) / _promedio1 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
363;73;1101;536;2480.739;352.5077;2.110705;False;False
Node;AmplifyShaderEditor.RangedFloatNode;31;-1471.064,525.2288;Inherit;False;Property;_blur4;blur4;3;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1474.87,108.7681;Inherit;False;Property;_blur2;blur2;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;20;-1872.826,68.40273;Inherit;False;InstancedProperty;_blur1;blur1;0;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;27;-1477.535,319.3774;Inherit;False;Property;_blur3;blur3;2;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1467.132,229.6776;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1460.66,435.5288;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1464.467,22.96819;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1896.766,-106.092;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-1312.532,204.1233;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;7;-1393.365,-439.5558;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-1306.061,409.9745;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-1304.868,19.46798;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-1304.983,-159.7793;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;37;-455.2251,391.9681;Inherit;True;Property;_TextureSample3;Texture Sample 3;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-433.8883,76.15258;Inherit;True;Property;_TextureSample2;Texture Sample 2;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-437.3529,-159.68;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-445.9861,-388.8989;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;215.0506,49.87602;Inherit;False;Property;_promedio1;promedio;4;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-26.34092,-58.39607;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;39;234.7381,-51.15778;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;476.8306,-115.3199;Float;False;True;-1;2;ASEMaterialInspector;0;2;motionBlur;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;26;0;20;0
WireConnection;26;1;27;0
WireConnection;29;0;20;0
WireConnection;29;1;31;0
WireConnection;24;0;20;0
WireConnection;24;1;25;0
WireConnection;28;0;1;0
WireConnection;28;1;26;0
WireConnection;30;0;1;0
WireConnection;30;1;29;0
WireConnection;22;0;1;0
WireConnection;22;1;24;0
WireConnection;21;0;1;0
WireConnection;21;1;20;0
WireConnection;37;0;7;0
WireConnection;37;1;30;0
WireConnection;36;0;7;0
WireConnection;36;1;28;0
WireConnection;35;0;7;0
WireConnection;35;1;22;0
WireConnection;9;0;7;0
WireConnection;9;1;21;0
WireConnection;38;0;9;0
WireConnection;38;1;35;0
WireConnection;38;2;36;0
WireConnection;38;3;37;0
WireConnection;39;0;38;0
WireConnection;39;1;40;0
WireConnection;0;0;39;0
ASEEND*/
//CHKSM=0A547E57FC8F445DAD8EC4133A066CEE8A01A2CD