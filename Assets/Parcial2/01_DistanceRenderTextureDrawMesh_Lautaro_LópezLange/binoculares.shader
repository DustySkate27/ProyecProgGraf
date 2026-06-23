// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "binoculares"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_center("center", Vector) = (0.3,0.5,0,0)
		_Vector1("Vector 1", Vector) = (-0.75,-0.7,0,0)
		_Vector0("Vector 0", Vector) = (0.7,0.5,0,0)
		_Float1("Float 1", Float) = 0
		_minFloat("minFloat", Float) = 0
		_Float0("Float 0", Float) = 0.3
		_maxFloat("maxFloat", Float) = 0.3
		_TextureSample0("Texture Sample 0", 2D) = "white" {}

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
			
			uniform float _minFloat;
			uniform float _maxFloat;
			uniform float2 _Vector0;
			uniform float _Float1;
			uniform float _Float0;
			uniform float2 _center;
			uniform sampler2D _TextureSample0;
			uniform float2 _Vector1;


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
				float smoothstepResult16 = smoothstep( _minFloat , _maxFloat , length( ( texCoord1 - _Vector0 ) ));
				float smoothstepResult8 = smoothstep( _Float1 , _Float0 , length( ( texCoord1 - _center ) ));
				float smoothstepResult24 = smoothstep( 0.0 , 0.23 , ( ( 1.0 - smoothstepResult16 ) + ( 1.0 - smoothstepResult8 ) ));
				

				finalColor = ( tex2D( _MainTex, texCoord1 ) * ( smoothstepResult24 + ( 1.0 - tex2D( _TextureSample0, ( texCoord1 - _Vector1 ) ) ) ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
415;73;647;732;1313.866;-410.0556;1;False;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1496.809,-56.79941;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;2;-1134.78,442.2597;Inherit;False;Property;_center;center;0;0;Create;True;0;0;0;False;0;False;0.3,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;18;-1049.209,175.4543;Inherit;False;Property;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0.7,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-1024.249,82.30666;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-1121.273,340.9306;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-848.3605,270.5771;Inherit;False;Property;_maxFloat;maxFloat;6;0;Create;True;0;0;0;False;0;False;0.3;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-834.9172,191.3654;Inherit;False;Property;_minFloat;minFloat;4;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;15;-852.4243,105.6703;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;6;-949.4466,364.2943;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-945.3828,529.201;Inherit;False;Property;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;0.3;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-931.9396,449.9894;Inherit;False;Property;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;8;-779.6395,396.2892;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-682.6172,137.6652;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;38;-1215.66,718.8032;Inherit;False;Property;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;-0.75,-0.7;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;-1196.339,628.8378;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;17;-502.9601,65.39388;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;10;-599.9826,324.0178;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-406.9885,314.9849;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-977.5624,631.463;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;bdf3fd0daba116b498ae1269d89d82f9;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;7;-1093.319,-345.8492;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;43;-590.2564,643.4163;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;24;-183.3581,314.3414;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;65.06049,313.6552;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-848.2776,-260.2041;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-31.28189,0.7286279;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;361.5917,1.292242;Float;False;True;-1;2;ASEMaterialInspector;0;2;binoculares;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;12;0;1;0
WireConnection;12;1;18;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;15;0;12;0
WireConnection;6;0;3;0
WireConnection;8;0;6;0
WireConnection;8;1;5;0
WireConnection;8;2;4;0
WireConnection;16;0;15;0
WireConnection;16;1;14;0
WireConnection;16;2;13;0
WireConnection;39;0;1;0
WireConnection;39;1;38;0
WireConnection;17;0;16;0
WireConnection;10;0;8;0
WireConnection;21;0;17;0
WireConnection;21;1;10;0
WireConnection;36;1;39;0
WireConnection;43;0;36;0
WireConnection;24;0;21;0
WireConnection;44;0;24;0
WireConnection;44;1;43;0
WireConnection;9;0;7;0
WireConnection;9;1;1;0
WireConnection;11;0;9;0
WireConnection;11;1;44;0
WireConnection;0;0;11;0
ASEEND*/
//CHKSM=6D454B345ACD8EBB1F8DA071E08566439367821A