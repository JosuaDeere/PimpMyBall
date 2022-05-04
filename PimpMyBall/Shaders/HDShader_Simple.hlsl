#include "Common.hlsl"

Texture2D<float4>	TextureVS: register ( t0 );  
SamplerState		SamplerVS: register ( s0 ); 
PS_INPUT VSMain ( VS_INPUT Input )
{
	float4 Q, N, V, vColor; 
	vColor =  Material.vEmissive; 
	vColor += Material.vAmbient; 
	
	N = normalize ( mul ( Input.Normal, mWV ) ); 
	
	Q = mul ( Input.Position, mWV );
	V = normalize ( float4 ( 0, 0, 0, 1 ) - Q ); 
	
	float4 vTangent = normalize ( mul ( Input.vTangent, mWV ) ); 
	
	float4 vBinormal = normalize ( mul ( Input.vBinormal, mWV ) ); 

	PS_INPUT Output; 
	Output.Position	= mul ( Input.Position, mWVP ); // mul ( Q, mProj )
	Output.TexPos	= Input.Position.xyz; 
	Output.Normal	= N;
	Output.Q		= Q; 
	Output.V		= V; 
	Output.Color	= vColor; 
	Output.TexCoord = Input.TexCoord; 
	Output.A = float4 ( vTangent.x, vBinormal.x, N.x, 0  ); 
	Output.B = float4 ( vTangent.y, vBinormal.y, N.y, 0  ); 
	Output.C = float4 ( vTangent.z, vBinormal.z, N.z, 0  ); 
	return Output; 
}


Texture2D<float4> Texture: register ( t0 );  
Texture2D<float4> Bump: register ( t1 ); 
Texture2D<float4> Reflex: register ( t2 ); 

SamplerState Sampler: register ( s0 );  
SamplerState SamplerBump: register ( s1 ); 
SamplerState SamplerReflex: register ( s2 )
{
    Filter		= MIN_MAG_MIP_TRILINEAR;
    AddressU	= Mirror;
    AddressV	= Mirror;
};

float4 PSMain ( PS_INPUT Input ) : SV_Target
{
	float4 vColor = Input.Color; 
	float4 N = normalize ( Input.Normal ); 

	vColor = vColor * Texture.Sample ( Sampler, Input.TexCoord ); 
	
	//BumpMapping
	float4 vNormalSample = Bump.Sample ( SamplerBump, Input.TexCoord ) * float4 ( 2,2,1,0) - float4 ( 1,1,0,0); 
	float4 vNormal = float4 (	dot ( Input.A, vNormalSample), 
								dot ( Input.B, vNormalSample),
								dot ( Input.C, vNormalSample), 0 ); 
	vNormal = vNormal * 1.0f + Input.Normal * 1.0f; 
	
	N = normalize ( vNormal ); 

	float2	Reflect = N.xy * 0.5; 
			Reflect.y *= -1; 
	Reflect.xy += float2 ( 0.5, 0.5 );
	float4 vReflectedColor	= vColor + Reflex.Sample( SamplerReflex, Reflect ) * 0.5;
	
	if ( Lights [ 0 ].LightTypeAndSwitches.y & 0x1 ) 
	{
		vReflectedColor += Lights [ 0 ].vAmbient * Material.vAmbient;
		vReflectedColor = Specular_and_Diffuse_Gain ( N, Input.Q, normalize ( Input.V), vReflectedColor, 0 ); 			
	}
	
	float sharpAmount = 15.0f;
    vReflectedColor += Texture.Sample ( Sampler, Input.TexCoord - 0.001) * sharpAmount;
    vReflectedColor -= Texture.Sample ( Sampler, Input.TexCoord + 0.001) * sharpAmount;
	
	float Threshold = -dot ( Input.Normal, float4 ( 0, 0, 1, 0 ) ); 
	
	return vReflectedColor;  	
}
