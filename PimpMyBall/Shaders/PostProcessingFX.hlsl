
cbuffer PARAMS 
{
	float fBlendFactor; 
	float Time;
}; 

struct VS_INPUT 
{
	float4 Pos : POSITION; 
	float2 TexCoord: TEXCOORD; 
};

struct PS_INPUT 
{
	float4 Pos: SV_Position; 
	float2 TexCoord: TEXCOORD; 
};

PS_INPUT VSMain ( VS_INPUT Input ) 
{
	PS_INPUT OutPut; 

	OutPut.Pos = Input.Pos; 
	OutPut.TexCoord = Input.TexCoord; 

	return OutPut; 
}

int Redondeo(float dato)
{
	int g=(int)dato;
	return g;
};


Texture2D<float4> TextInput: register ( t0 ); 
SamplerState Sampler: register ( s0 ); 

float4 PSMain ( PS_INPUT Input ) : SV_Target
{/*
	float4 vColor = TextInput.Sample ( Sampler, Input.TexCoord ); 
	float4 BW = dot ( vColor.rgb, vColor.rgb ) / 3;  
	float4 Blend = vColor * ( 1 - fBlendFactor ) + BW * ( fBlendFactor );
	
	return Blend; */
	//Dream vision
	//float2 uv = Input.TexCoord;
	//float4 Tex = TextInput.Sample( Sampler, uv.xy  );

	//Tex += TextInput.Sample( Sampler, uv.xy +0.001  );

	//Tex += TextInput.Sample( Sampler, uv.xy +0.003 );

	//Tex += TextInput.Sample( Sampler, uv.xy +0.005 );

	//Tex += TextInput.Sample( Sampler, uv.xy +0.007 );

	//Tex += TextInput.Sample( Sampler, uv.xy +0.009);

	//Tex += TextInput.Sample( Sampler, uv.xy +0.011 );


	//Tex += TextInput.Sample( Sampler, uv.xy -0.001 );

	//Tex += TextInput.Sample( Sampler, uv.xy -0.003 );

	//Tex += TextInput.Sample( Sampler, uv.xy -0.005);

	//Tex += TextInput.Sample( Sampler, uv.xy -0.007 );

	//Tex += TextInput.Sample( Sampler, uv.xy -0.009);

	//Tex += TextInput.Sample( Sampler, uv.xy -0.011 );

	//float Ayuda = (Tex.r+ Tex.g + Tex.b) / 3;
	//Tex.rgb = float3 (Ayuda, Ayuda, Ayuda);
	//Tex = Tex / 9.5;
	//Tex.a = 0.8;
	//return Tex;

	//thermal vison

	//float2 uv = Input.TexCoord;
	// 
	//float4 tc = float4( 1.0, 0.0, 0.0, 0.0);
	// 
	//   float4 PixColor = TextInput.Sample( Sampler, uv.xy  ) ;
	////float4 PixColor = Input.Color;
	//   float4 ThermalColors [ 3 ];
	//   ThermalColors [ 0 ] = float4(0.12, 0.23, 0.8, 1.0);
	//   ThermalColors [ 1 ] = float4(1.0, 1.0, 0.0, 1.0);
	//   ThermalColors [ 2 ] = float4(1.0, 0.0, 0.0, 1.0);
	//   float Lum = (PixColor.r + PixColor.g + PixColor.b) / 3.;
	//   int Index = (Lum < 0.5) ? 0 : 1;
	//tc = lerp( ThermalColors [ Index ], ThermalColors[ Index + 1 ] , (Lum - float4(ThermalColors[ Index ]) * 0.5) );

	//if( Index )
	//	tc.a = 1;
	//else
	//	tc.a = 0.5;
	//   //tc = lerp( ThermalColors [ Index ], ThermalColors[ Index + 1], ( Lum - float4 (ThermalColors) * 0.5 ) / 0.5);
	//
	//return tc;

	//Frosted effect on scene
		
	//float2 uv = Input.TexCoord; 
	//
	//uv.y = uv.y + (sin ( uv.y *100 )* 0.03 );
	//uv.x = uv.x + (cos ( uv.x * 50 ) * 0.03 );
	//float4 Color =TextInput.Sample( Sampler, uv.xy ) *0.7;
	//return Color ;

	//uint SizeX;
	//uint SizeY;
	//uint nLevels;
	//TextInput.GetDimensions(0, SizeX, SizeY, nLevels);
	//float dx=5.0/SizeX;
	//float dy=5.0/SizeY;

	//float2 coord= float2( dx * Redondeo( Input.TexCoord.x / dx), dy * Redondeo(Input.TexCoord.y / dy));
	//float4 Color= (TextInput.Sample(Sampler, coord));
	//return Color;
	
	
}
