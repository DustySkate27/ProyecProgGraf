// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sprites"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_Color0("Color 0", Color) = (0.3260422,1,0,1)
		_Ramp("Ramp", 2D) = "white" {}
		_Flow("Flow", 2D) = "white" {}
		_distortionmask("distortion mask", 2D) = "white" {}
		_Color1("Color 1", Color) = (1,0,0,1)
		_color("color", 2D) = "white" {}
		_rotatetex("rotate tex", 2D) = "white" {}
		_position("position", Vector) = (0,-0.8,1,3)
		_normal("normal", 2D) = "white" {}
		_rotmask("rot mask", 2D) = "white" {}
		_amount("amount", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		
		
		Pass
		{
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform sampler2D _color;
			uniform sampler2D _normal;
			uniform float4 _color_ST;
			uniform float _amount;
			uniform sampler2D _distortionmask;
			uniform sampler2D _Ramp;
			uniform sampler2D _Flow;
			uniform float4 _Flow_ST;
			uniform float4 _Color0;
			uniform sampler2D _rotatetex;
			uniform float4 _position;
			uniform sampler2D _rotmask;
			uniform float4 _Color1;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_color = IN.texcoord.xy * _color_ST.xy + _color_ST.zw;
				float2 MainUvs222_g4 = uv_color;
				float4 tex2DNode65_g4 = tex2D( _normal, MainUvs222_g4 );
				float4 appendResult82_g4 = (float4(0.0 , tex2DNode65_g4.g , 0.0 , tex2DNode65_g4.r));
				float2 temp_output_84_0_g4 = (UnpackScaleNormal( appendResult82_g4, _amount )).xy;
				float2 panner179_g4 = ( 1.0 * _Time.y * float2( 0,0 ) + MainUvs222_g4);
				float2 temp_output_71_0_g4 = ( ( temp_output_84_0_g4 * tex2D( _distortionmask, MainUvs222_g4 ).g ) + panner179_g4 );
				float4 tex2DNode96_g4 = tex2D( _color, temp_output_71_0_g4 );
				float2 uv_Flow = IN.texcoord.xy * _Flow_ST.xy + _Flow_ST.zw;
				float4 tex2DNode14_g2 = tex2D( _Flow, uv_Flow );
				float2 appendResult20_g2 = (float2(tex2DNode14_g2.r , tex2DNode14_g2.g));
				float TimeVar197_g2 = _Time.y;
				float2 temp_cast_0 = (TimeVar197_g2).xx;
				float2 temp_output_18_0_g2 = ( appendResult20_g2 - temp_cast_0 );
				float4 tex2DNode72_g2 = tex2D( _Ramp, temp_output_18_0_g2 );
				float4 temp_output_57_0_g3 = _position;
				float2 temp_output_2_0_g3 = (temp_output_57_0_g3).zw;
				float2 temp_cast_1 = (1.0).xx;
				float2 temp_output_13_0_g3 = ( ( ( IN.texcoord.xy + (temp_output_57_0_g3).xy ) * temp_output_2_0_g3 ) + -( ( temp_output_2_0_g3 - temp_cast_1 ) * 0.5 ) );
				float TimeVar197_g3 = _Time.y;
				float cos17_g3 = cos( TimeVar197_g3 );
				float sin17_g3 = sin( TimeVar197_g3 );
				float2 rotator17_g3 = mul( temp_output_13_0_g3 - float2( 0.5,0.5 ) , float2x2( cos17_g3 , -sin17_g3 , sin17_g3 , cos17_g3 )) + float2( 0.5,0.5 );
				float4 tex2DNode97_g3 = tex2D( _rotatetex, rotator17_g3 );
				float temp_output_115_0_g3 = step( ( (temp_output_13_0_g3).y + -0.5 ) , 0.0 );
				float lerpResult125_g3 = lerp( 1.0 , tex2D( _rotmask, IN.texcoord.xy ).g , ( 1.0 - temp_output_115_0_g3 ));
				float4 temp_output_192_0_g3 = tex2D( _color, uv_color );
				
				fixed4 c = ( tex2DNode96_g4 + ( ( tex2DNode72_g2 * tex2DNode14_g2.a ) * _Color0 ) + ( ( ( tex2DNode97_g3 * lerpResult125_g3 * tex2DNode97_g3.a ) * _Color1 ) + temp_output_192_0_g3 ) );
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
368;81;1092;526;3180.079;544.2779;2.772765;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;16;-1636.074,661.0563;Inherit;True;Property;_color;color;12;0;Create;True;0;0;0;False;0;False;80ab37a9e4f49c842903bb43bdd7bcd2;80ab37a9e4f49c842903bb43bdd7bcd2;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;11;-1573.801,163.4496;Inherit;True;Property;_Ramp;Ramp;8;0;Create;True;0;0;0;False;0;False;131633c45b26caa4f9673a16077a1970;131633c45b26caa4f9673a16077a1970;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;8;-1561.79,-12.19962;Inherit;False;Property;_Color0;Color 0;7;0;Create;True;0;0;0;False;0;False;0.3260422,1,0,1;0.3204558,1,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1581.307,364.6202;Inherit;True;Property;_Flow;Flow;9;0;Create;True;0;0;0;False;0;False;0f887c1218c9ff641b128d1ee0c2bd11;0f887c1218c9ff641b128d1ee0c2bd11;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;17;-1477.037,1094.939;Inherit;True;Property;_rotatetex;rotate tex;13;0;Create;True;0;0;0;False;0;False;a99649a3ac7df724eb781c969383e632;a99649a3ac7df724eb781c969383e632;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;5;-1441.375,-257.6519;Inherit;False;Property;_amount;amount;17;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;6;-1290.785,-179.2038;Inherit;True;Property;_distortionmask;distortion mask;10;0;Create;True;0;0;0;False;0;False;None;c68296334e691ed45b62266cbc716628;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;15;-1330.075,672.9805;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;14;-1457.931,902.8947;Inherit;False;Property;_Color1;Color 1;11;0;Create;True;0;0;0;False;0;False;1,0,0,1;0,0.07011531,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;20;-1251.66,1497.725;Inherit;False;Property;_position;position;14;0;Create;True;0;0;0;False;0;False;0,-0.8,1,3;0,-0.08,1,3;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1330.963,-464.3453;Inherit;True;Property;_normal;normal;15;0;Create;True;0;0;0;False;0;False;None;302951faffe230848aa0d3df7bb70faa;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1421.291,1287.101;Inherit;True;Property;_rotmask;rot mask;16;0;Create;True;0;0;0;False;0;False;596678c53fd54a640bf95ba7dfafd092;596678c53fd54a640bf95ba7dfafd092;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;1;-982.3432,-366.0096;Inherit;False;UI-Sprite Effect Layer;0;;4;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,1,177,1,182,0,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.FunctionNode;13;-969.2658,1039.986;Inherit;True;UI-Sprite Effect Layer;0;;3;789bf62641c5cfe4ab7126850acc22b8;18,74,2,204,2,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,1,98,1,234,0,126,0,129,1,130,1,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.FunctionNode;7;-1117.413,238.5132;Inherit;True;UI-Sprite Effect Layer;0;;2;789bf62641c5cfe4ab7126850acc22b8;18,74,1,204,1,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,1,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-201.5177,383.6337;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-60.38516,320.9799;Float;False;True;-1;2;ASEMaterialInspector;0;6;Sprites;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;15;0;16;0
WireConnection;1;37;16;0
WireConnection;1;75;4;0
WireConnection;1;80;5;0
WireConnection;1;188;6;0
WireConnection;13;192;15;0
WireConnection;13;39;14;0
WireConnection;13;37;17;0
WireConnection;13;101;18;0
WireConnection;13;57;20;0
WireConnection;7;39;8;0
WireConnection;7;37;11;0
WireConnection;7;33;12;0
WireConnection;21;0;1;0
WireConnection;21;1;7;0
WireConnection;21;2;13;0
WireConnection;0;0;21;0
ASEEND*/
//CHKSM=FDEFBE47B903D53DD31B31CFF643C16AFB2D0C8B