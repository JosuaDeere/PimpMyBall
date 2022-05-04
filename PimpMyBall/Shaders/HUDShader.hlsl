cbuffer Params
{
	matrix	mWorld, 
			mView, 
			mProj,
			mWV, 
			mWVP; 
	float4	vColor; 
}; 

struct VS_INPUT
{
	float4 Position: POSITION; 
	float4 Normal: NORMAL; 
	float2 Texture: TEXCOORD; 
}; 

struct PS_INPUT
{
	float4 Position: SV_Position; 
	float4 Col : COLOR;
	float4 Normal: NORMAL; 
	float2 Texture: TEXCOORD; 
}; 

PS_INPUT VSMain ( VS_INPUT input ) 
{
	PS_INPUT output = (PS_INPUT)0; 
	float4 Normal = normalize ( mul ( input.Normal, mWV ) ); 

	output.Position = mul ( input.Position, mWVP );
	output.Normal	= Normal; 
	output.Texture	= input.Texture; 
	return output; 
}

Texture2D<float4>	Texture: register( t0 ); 
SamplerState		Stexture : register(s0)
{
    Filter		= MIN_MAG_MIP_TRILINEAR;
    AddressU	= Mirror;
    AddressV	= Mirror;
};

float4 PSMain ( PS_INPUT input ) : SV_Target 
{  
	float4 vColor = Texture.Sample ( Stexture, input.Texture ); 
	
	return vColor; 
}