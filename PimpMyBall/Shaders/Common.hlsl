struct LIGHT 
{
	uint4	LightTypeAndSwitches;  
	float4	vPosition, 
			vDirection, 
			vDiffuse, 
			vSpecular, 
			vAmbient, 
			vAttenuation; 
	float4	LightPowerAndRange; 

}; 


struct MATERIAL 
{
	float4	vDiffuse,        /* Diffuse color RGBA */
			vAmbient,        /* Ambient color RGB */
			vSpecular,       /* Specular 'shininess' */
			vEmissive;       /* Emissive color RGB */
	float	fPower;

};


cbuffer Params
{
	matrix	mWorld, 
			mView, 
			mProj,
			mWV, 
			mWVP; 
	LIGHT	Lights [ 1 ]; 
	MATERIAL Material; 
}

struct VS_INPUT 
{
	float4 Position	: POSITION; 
	float4 Normal	: NORMAL0; 
	float2 TexCoord : TEXCOORD; 
	float4 vTangent : NORMAL1; 
	float4 vBinormal: NORMAL2; 
	float4 vNormal	: NORMAL3; 
}; 

struct PS_INPUT 
{
	float4 Position:	SV_POSITION; 
	float3 TexPos:		POSITION; 
	float4 Normal:		NORMAL0; 
	float4 Color:		COLOR; 
	float2 TexCoord :	TEXCOORD; 
	float4 Q :			V_POS; 
	float4 V :			View; 
	float4 A			: NORMAL1; 
	float4 B			: NORMAL2; 
	float4 C			: NORMAL3; 
}; 

float4 Specular_and_Diffuse_Gain ( float4 N, float4 Q, float4 V, float4 vTempColor, int it )
{
	float4 vColor = vTempColor; 

	float4	L		= mul ( Lights [ it ].vDirection, mView ), 
			P		= mul ( Lights [ it ].vPosition, mView ),
			H, 
			Ls; 
	float	d			 = distance( Q, P ), 
			fAttenuation = 1 / dot ( Lights [ it ].vAttenuation, 
									float4 ( 1, d, d * d, 0 ) ); 

	switch ( Lights [ it ].LightTypeAndSwitches.x ) //LightType  
	{
	case 0: //Directional
		{
			H = normalize ( V - L ); 
			float ISpecular = pow ( max ( 0, dot ( H, N ) ), Material.fPower ); 
			vColor += ISpecular * Lights [ it ].vSpecular * Material.vSpecular; 

			float ILambert = max ( 0, -dot ( N, L ) ); 
			////Diffuse
			vColor += ILambert * Lights [ it ].vDiffuse * Material.vDiffuse;

		}
		break;
	case 2:
	case 1: //Point 
		{
			if ( d > Lights [ it ].LightPowerAndRange.y )
				break; 

			L = normalize ( Q - P );

			float ISpot = 1.0f; 

			if ( Lights [ it ].LightTypeAndSwitches.x == 2 ) 
			{
				Ls	= mul ( Lights [ it ].vDirection,mView );
				ISpot = pow( max(0, dot( L, Ls ) ), Lights [ it ].LightPowerAndRange.x );
			}	
			//Specular

			H = normalize ( V - L );
			float ISpecular = pow ( max ( 0, dot ( H, N )), Material.fPower );
			vColor += ISpot * ISpecular * fAttenuation * Lights [ it ].vSpecular * Material.vSpecular;
			float ILambert = max( 0, -dot( N, L ) );
			//Difusse
			vColor += ISpot * ILambert * fAttenuation * Lights [ it ].vDiffuse * Material.vDiffuse;
		}
		break; 
	}

	return vColor; 
}
