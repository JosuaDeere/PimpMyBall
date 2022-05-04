#include "Common.hlsl"

PS_INPUT VSMain ( VS_INPUT Input )
{
	PS_INPUT Output = (PS_INPUT)0;
	float4 Normal = normalize ( mul ( Input.Normal, mWV ) ); 
	
	Output.Position = mul ( Input.Position, mWVP );
	Output.Normal = Normal; 
	Output.TexCoord = Input.TexCoord;
	return Output;
}


Texture2D<float4> Texture: register ( t0 ); 
SamplerState Sampler: register ( s0 ); 

Texture2D<float4> ReflexibleTexture: register ( t1 ); 
SamplerState SamplerReflexible: register ( s1 ); 

float4 PSMain ( PS_INPUT Input ) : SV_Target
{ 
	float4 N = normalize ( Input.Normal ); 
	float4 vColor = Texture.Sample ( Sampler, Input.TexCoord ); 

	/*float4 N = normalize ( Input.Normal );  
	float2	Reflect = N.xy * 0.5; 
			Reflect.y *= -1; 
	Reflect.xy += float2 ( 0.5, 0.5 );
*/
	//vColor	*= ReflexibleTexture.Sample( SamplerReflexible, Reflect ) * 0.8;

	if ( Lights [ 0 ].LightTypeAndSwitches.y & 0x1 ) 
	{
		vColor += Lights [ 0 ].vAmbient * Material.vAmbient;
		vColor = Specular_and_Diffuse_Gain ( N, Input.Q, normalize ( Input.V), vColor, 0 ); 			
	}


	return vColor; 
}


