#include "Common.hlsl"

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

	PS_INPUT Output = (PS_INPUT)0; 
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
Texture2D<float4> Reflex: register ( t1 ); 

SamplerState Sampler: register ( s0 );   
SamplerState SamplerReflex: register ( s1 )
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
	
	float2	Reflect = N.xy * 0.5; 
			Reflect.y *= -1; 
	Reflect.xy += float2 ( 0.5, 0.3 );
	float4 vReflectedColor	= vColor + Reflex.Sample( SamplerReflex, Reflect ) * 0.8;
	
	if ( Lights [ 0 ].LightTypeAndSwitches.y & 0x1 ) 
	{
		vReflectedColor += Lights [ 0 ].vAmbient * Material.vAmbient;
		vReflectedColor = Specular_and_Diffuse_Gain ( N, Input.Q, normalize ( Input.V ), vReflectedColor, 0 ); 			
	}
	
	vReflectedColor.w = 0.8f; 
	
	return vReflectedColor;  

}
