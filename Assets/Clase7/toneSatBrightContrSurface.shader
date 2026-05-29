// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "toneSatBrightContrSurface"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_color("color", Color) = (1,0,0,0)
		_contrast("contrast", Float) = 10
		_brightness("brightness", Range( -1 , 1)) = 0.1220945
		_saturation("saturation", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
			
			uniform float _contrast;
			uniform float4 _color;
			uniform float _brightness;
			uniform float _saturation;
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}


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
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				

				finalColor = saturate( ( ( CalculateContrast(_contrast,( tex2D( _MainTex, uv_MainTex ) * _color )) + _brightness ) * _saturation ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
363;73;1101;535;1559.228;380.2961;1.792855;True;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-1248.371,-37.5722;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1090.682,-44.39649;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-1012.041,171.2086;Inherit;False;Property;_color;color;0;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-764.0269,-12.4576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-676.5364,100.1636;Inherit;False;Property;_contrast;contrast;1;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;15;-503.4833,-13.17071;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;-22.72;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-455.6303,145.2056;Inherit;False;Property;_brightness;brightness;2;0;Create;True;0;0;0;False;0;False;0.1220945;0.1220945;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-215.541,-10.83748;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-121.2102,146.9554;Inherit;False;Property;_saturation;saturation;3;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;71.16083,-5.28795;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;14;394.2664,-5.188323;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;613.8759,-6.582899;Float;False;True;-1;2;ASEMaterialInspector;0;2;toneSatBrightContrSurface;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;2;0;1;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;15;1;4;0
WireConnection;15;0;16;0
WireConnection;12;0;15;0
WireConnection;12;1;13;0
WireConnection;10;0;12;0
WireConnection;10;1;11;0
WireConnection;14;0;10;0
WireConnection;0;0;14;0
ASEEND*/
//CHKSM=A028AA6494243AF1D004D24F614B65E612A81ED2