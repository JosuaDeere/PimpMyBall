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
	float3 Pos : POSITION; 
	float4 Col: COLOR;
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
	output.Pos		= input.Position.xyz; 
	return output; 
}

TextureCube			Cube: register( t0 );
Texture2D<float4>	Texture: register( t1 ); 
SamplerState		Stexture : register(s0)
{
    Filter		= MIN_MAG_MIP_TRILINEAR;
    AddressU	= Mirror;
    AddressV	= Mirror;
};

float4 PSMain ( PS_INPUT input ) : SV_Target 
{
	float4 N = normalize( input.Normal );
      
	float4 vColor = Cube.Sample ( Stexture, input.Pos ); 
	
	float2	Reflect	= N.xy * 0.5; 
			Reflect.y *= -1; 
	Reflect.xy += float2 ( 0.5, 0.5 );

	float4 lastColor = vColor + Texture.Sample( Stexture, Reflect ) * 0.5;

	return lastColor; 
}