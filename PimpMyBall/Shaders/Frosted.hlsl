cbuffer Params
{
	float4	vSwitches, 
			vDeltas;
}

struct VS_INPUT 
{
	float4 Position	: POSITION; 
	float2 TexCoord : TEXCOORD; 
}; 

struct PS_INPUT 
{ 
	float4 Position:	SV_POSITION; 
	float4 Color:		COLOR; 
	float2 TexCoord :	TEXCOORD; 

}; 

PS_INPUT VSMain ( VS_INPUT Input )
{
	PS_INPUT Output = (PS_INPUT)0; 

	float4 vColor	= float4(1,1,1,1);
	Output.Position	= Input.Position;
	Output.Color	= vColor;

	Output.TexCoord = Input.TexCoord; 
	return Output; 
}


Texture2D<float4> Texture : register (t0); 
SamplerState Sampler : register (s0); 

float4 PSMain ( PS_INPUT Input ) : SV_Target
{
	float4 Color; 

	if ( vSwitches.x )
	{
		float2 uv = Input.TexCoord; 
		uv.y = uv.y + (sin ( uv.y *100 )* vDeltas.x );
		uv.x = uv.x + (cos ( uv.x * 50 ) * vDeltas.x );
		Color = Texture.Sample( Sampler, uv.xy  ) * 0.9;
		return Color ;
	}
	else if ( vSwitches.y ) 
	{
		float4 ShockWave = float4( 10.0, 0.8, 0.1, 1);
		float2 PositionShock=float2( vDeltas.z, vDeltas.w ); // pasar datos del mouse
		float2 uv = Input.TexCoord;
		float2 UV2 = uv;
		float2 UV3 = uv;
		float Distance = distance ( uv, PositionShock );
		Color = Texture.Sample ( Sampler, Input.TexCoord );
		
		if( ( Distance <= ( vDeltas.x + vDeltas.y + ShockWave.z ) ) && ( Distance >= ( ( vDeltas.x + vDeltas.y ) - ShockWave.z ) ) )
		{
			float Diff = ( Distance - ( vDeltas.x + vDeltas.y ) );
			
			float PowDiff = 1.0 - pow( abs( Diff* ShockWave.x), ShockWave.y);

			float DiffTime = Diff * PowDiff;

			float2 Diffuv = normalize ( uv - PositionShock );
				UV2 = uv + ( Diffuv * DiffTime);
			
			Color = Texture.Sample ( Sampler, UV2 );
		}	
	}
	else if ( vSwitches.z ) 
	{
		Color = Texture.Sample( Sampler, Input.TexCoord );
		Color.a = 0.8f; 
	}
	else 
		Color = Texture.Sample( Sampler, Input.TexCoord ); 
	
	return Color; 
}
