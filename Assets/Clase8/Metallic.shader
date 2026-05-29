// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Metallic"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_reflex("reflex", Color) = (0.5849056,0.5849056,0.5849056,1)
		_Ramp1("Ramp", 2D) = "white" {}
		_Flow1("Flow", 2D) = "white" {}
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
			uniform sampler2D _Ramp1;
			uniform sampler2D _Flow1;
			uniform float4 _Flow1_ST;
			uniform float4 _reflex;

			
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

				float2 uv_Flow1 = IN.texcoord.xy * _Flow1_ST.xy + _Flow1_ST.zw;
				float4 tex2DNode14_g2 = tex2D( _Flow1, uv_Flow1 );
				float2 appendResult20_g2 = (float2(tex2DNode14_g2.r , tex2DNode14_g2.g));
				float TimeVar197_g2 = _Time.y;
				float2 temp_cast_0 = (TimeVar197_g2).xx;
				float2 temp_output_18_0_g2 = ( appendResult20_g2 - temp_cast_0 );
				float4 tex2DNode72_g2 = tex2D( _Ramp1, temp_output_18_0_g2 );
				float4 color18 = IsGammaSpace() ? float4(0.6799573,0.7405482,0.754717,1) : float4(0.4199747,0.5079181,0.5299,1);
				float4 temp_output_192_0_g2 = ( color18 * tex2D( _Flow1, uv_Flow1 ) );
				
				fixed4 c = ( float4( 0,0,0,0 ) + ( ( ( tex2DNode72_g2 * tex2DNode14_g2.a ) * _reflex ) + temp_output_192_0_g2 ) );
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
368;81;1092;526;2815.985;567.8528;2.627475;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;13;-1477.096,387.9643;Inherit;True;Property;_Flow1;Flow;9;0;Create;True;0;0;0;False;0;False;40a7b28fa010f3640a1b4b6611327c62;0f887c1218c9ff641b128d1ee0c2bd11;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;19;-1324.642,-92.46538;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;-1173.076,-259.5835;Inherit;False;Constant;_color;color;4;0;Create;True;0;0;0;False;0;False;0.6799573,0.7405482,0.754717,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;11;-1496.247,84.10526;Inherit;False;Property;_reflex;reflex;7;0;Create;True;0;0;0;False;0;False;0.5849056,0.5849056,0.5849056,1;0.3204558,1,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-986.7277,2.315675;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1196.122,271.7079;Inherit;True;Property;_Ramp1;Ramp;8;0;Create;True;0;0;0;False;0;False;131633c45b26caa4f9673a16077a1970;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;14;-743.911,256.944;Inherit;True;UI-Sprite Effect Layer;0;;2;789bf62641c5cfe4ab7126850acc22b8;18,74,1,204,1,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,1,98,0,234,0,126,0,129,1,130,0,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-168.9389,3.788882;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;70.79999,-3.2;Float;False;True;-1;2;ASEMaterialInspector;0;6;Metallic;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;19;0;13;0
WireConnection;17;0;18;0
WireConnection;17;1;19;0
WireConnection;14;192;17;0
WireConnection;14;39;11;0
WireConnection;14;37;12;0
WireConnection;14;33;13;0
WireConnection;15;1;14;0
WireConnection;0;0;15;0
ASEEND*/
//CHKSM=ED3712FEDE62D24A04E736CF64ECA4920671FF5C