// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ultimateToonWater"
{
	Properties
	{
		_bias("bias", Float) = 0
		_Tilling("Tilling", Vector) = (0,0,0,0)
		_scale("scale", Float) = 0
		_power("power", Float) = 0
		_pannerSpeed("pannerSpeed", Float) = 0
		_pannerUV("pannerUV", Vector) = (0,0,0,0)
		_panner("panner", 2D) = "white" {}
		_distortionProportion("distortionProportion", Range( 0 , 1)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Texture0;
			uniform float2 _pannerUV;
			uniform float _pannerSpeed;
			uniform float2 _Tilling;
			uniform sampler2D _panner;
			uniform float4 _panner_ST;
			uniform float _distortionProportion;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _bias;
			uniform float _scale;
			uniform float _power;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord17 = i.ase_texcoord1.xy * _Tilling + float2( 0,0 );
				float2 uv_panner = i.ase_texcoord1.xy * _panner_ST.xy + _panner_ST.zw;
				float4 tex2DNode16 = tex2D( _panner, uv_panner );
				float2 appendResult18 = (float2(tex2DNode16.r , tex2DNode16.g));
				float2 lerpResult21 = lerp( texCoord17 , ( appendResult18 + texCoord17 ) , _distortionProportion);
				float2 panner14 = ( 1.0 * _Time.y * ( _pannerUV * _pannerSpeed ) + lerpResult21);
				float4 screenPos = i.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth1 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth1 = abs( ( screenDepth1 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
				
				
				finalColor = saturate( ( tex2D( _Texture0, panner14 ) + ( 1.0 - pow( ( ( distanceDepth1 + _bias ) * _scale ) , _power ) ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
363;73;1101;653;1620.268;483.1485;2.083807;True;False
Node;AmplifyShaderEditor.Vector2Node;15;-1999.729,-34.96104;Inherit;False;Property;_Tilling;Tilling;1;0;Create;True;0;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;16;-2092.534,-360.7872;Inherit;True;Property;_panner;panner;6;0;Create;True;0;0;0;False;0;False;-1;f7e96904e8667e1439548f0f86389447;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-1134.086,456.7168;Inherit;False;Property;_bias;bias;0;0;Create;True;0;0;0;False;0;False;0;4.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-1740.534,-243.7872;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;1;-1427.902,340.5522;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1828.602,-34.85805;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-1172.386,327.8169;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-973.6868,459.8168;Inherit;False;Property;_scale;scale;2;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1584.534,-144.7872;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1743.534,91.21277;Inherit;False;Property;_distortionProportion;distortionProportion;7;0;Create;True;0;0;0;False;0;False;0;0.189;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;12;-1955.697,190.1289;Inherit;False;Property;_pannerUV;pannerUV;5;0;Create;True;0;0;0;False;0;False;0,0;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;11;-1897.098,357.7899;Inherit;False;Property;_pannerSpeed;pannerSpeed;4;0;Create;True;0;0;0;False;0;False;0;-0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-831.4868,445.7167;Inherit;False;Property;_power;power;3;0;Create;True;0;0;0;False;0;False;0;0.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1012.587,328.7169;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-1442.534,-61.78725;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1765.248,232.4511;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;7;-841.4868,327.0169;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;14;-1066.175,68.65915;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;23;-1087.58,-276.162;Inherit;True;Property;_Texture0;Texture 0;8;0;Create;True;0;0;0;False;0;False;None;f7e96904e8667e1439548f0f86389447;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;22;-823.2602,-162.1064;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;9;-668.7537,324.8694;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-459.3687,0.8300371;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;26;-252.9825,-0.9804149;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;27;0,0;Float;False;True;-1;2;ASEMaterialInspector;100;1;ultimateToonWater;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;18;0;16;1
WireConnection;18;1;16;2
WireConnection;17;0;15;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;20;0;18;0
WireConnection;20;1;17;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;21;0;17;0
WireConnection;21;1;20;0
WireConnection;21;2;19;0
WireConnection;13;0;12;0
WireConnection;13;1;11;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;14;0;21;0
WireConnection;14;2;13;0
WireConnection;22;0;23;0
WireConnection;22;1;14;0
WireConnection;9;0;7;0
WireConnection;25;0;22;0
WireConnection;25;1;9;0
WireConnection;26;0;25;0
WireConnection;27;0;26;0
ASEEND*/
//CHKSM=D1A621898B08498EC91C0604BF0A7BD44AD4FEA5