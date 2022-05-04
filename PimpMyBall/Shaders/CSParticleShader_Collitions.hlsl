//Compute Sample
#define EPSILON 0.0001

struct TRIANGLE
{
	float4	vPlane [ 3 ],
			NPlane;
	float	m_dID,
			m_fKd, 
			m_fKr,
			m_fDeltaVelocity; 
};

struct PARTICLE_ATTRIBUTES
{
	float	ulID;			//Identificador asociativo. (opcional)
	float	fAge;			//Tiempo de vida en milisegundos
	float	ulMaxAge;		//Tiempo máximo de vida ulAge<ulMaxAge
	float4	m_vPosition;
	float4	m_vVelocity;
	float4	m_vAcceleration;
	float	m_fKd;          //Coeficiente de friccion dinámica
	float   m_fKr;          //Coeficiente de rebote
	float	m_bOnColition;
};

cbuffer MeshInfo
{
	float4	vPlanesInfo; 
};

bool CheckCollision( float4 V0, float4 V1, float4 V2, float4 P )
{
	float A,B,C,D,F;
	float4	D0,
			D1,
			D2;

	D0 = V1 - V0;
	D1 = V2 - V0;
	D2 = P	- V0;

	A = dot( D2,D0 );
	B = dot( D0,D0 );
	C = dot( D1, D0 );
	D = dot( D2, D1 );
	F = dot( D1, D1 );

	float det	= 1.0f / ( B * F - C * C );
	float w1	= ( F * A - C * D ) * det;
	float w2	= ( B * D - C * A ) * det;
	return ( ( w1 >= 0 ) && ( w2 >= 0 ) && ( ( w1 + w2 ) <= 1 ) ) ? true : false;
};

StructuredBuffer<PARTICLE_ATTRIBUTES>	Particles		: register(t0);
StructuredBuffer<TRIANGLE>				Planes			: register(t1);
RWStructuredBuffer<PARTICLE_ATTRIBUTES>	ParticlesOutput	: register(u0);

[numthreads(1,1,1)]
void CSMain( uint3 ThreadID:SV_DispatchThreadID )
{
	float	Num = 0, 
			Den = 0;
	float4	D0, 
			D1;
	PARTICLE_ATTRIBUTES A, B;
	
	A = B = Particles[ ThreadID.x ];

	float4	vVelocity, 
			vGravity = float4 ( 0, -9.81f * vPlanesInfo.x, 0, 0 ), 
			vResult; 
	vVelocity = B.m_vAcceleration + vGravity; 
	vVelocity = vVelocity.xyzw * vPlanesInfo.x; 
	B.m_vVelocity = B.m_vVelocity + vVelocity; 
	B.m_vPosition = B.m_vPosition + B.m_vVelocity;  
	

	for( int i = 0; i < (int)vPlanesInfo.y; i++ )
	{	
		if( dot( A.m_vPosition, Planes[ i ].NPlane ) * dot ( B.m_vPosition, Planes[ i ].NPlane  ) < 0 ) //Condición de colisión
		{
			float4 RayDir;
			RayDir = normalize( A.m_vVelocity );

			Num = -dot( A.m_vPosition, Planes[ i ].NPlane );
			Den = dot( RayDir, Planes[ i ].NPlane );
			
			if( abs( Den ) > EPSILON )
			{
				float u = Num / Den;
				float4 Intersection;

				Intersection = A.m_vPosition + ( RayDir * u );

				if( CheckCollision( Planes[ i ].vPlane[0], Planes[ i ].vPlane[1], Planes[ i ].vPlane[2], Intersection ) )
				{
					float4 Vn, Vp, Vcc;

					float	Kr, /*!< Constante de rebote. */
							Kd; /*!< Constante de fricción. */
					
					B.ulID = Planes [ i ].m_dID; 
					Kr = B.m_fKr * Planes [ i ].m_fKr;
					Kd = B.m_fKd * Planes [ i ].m_fKd;
					//-N * dot ( V, N ) * Kr + ( V - N*dot ( V, N ) ) * kd
					float4 tmpPlane = Planes[ i ].NPlane;
					tmpPlane.w = 0.0f;
					Vn = tmpPlane * dot ( tmpPlane, A.m_vVelocity ); /*!< -N * dot ( V, N ) = Vn*/						
					//Vn.w = 0.0f;

					Vp = A.m_vVelocity - Vn; /*!< vPlanetor resultante. V - Vn = Vp */	
					Vn = Vn * -Kr; /*!< Vr conserva el valor de rebote. Vn * kr */
					Vp = Vp * Kd; /*!< Valor resultante de fricción. Vp * kd */
					Vcc = Vn + Vp; /*!< Suma de vPlanetores fricción y rebote. */
					float4 vCorrection;
					vCorrection = tmpPlane * 0.001f; /*!< Se posiciona epsilon encima del plano. */
					Intersection = vCorrection + Intersection; 
					B.m_bOnColition = 1.0f; 
					B.m_vPosition = Intersection;
					B.m_vVelocity = Vcc.xyzw * Planes [ i ].m_fDeltaVelocity; /*!< Se asigna la velocidad corregida. */
				}
			}
		}
	}

	ParticlesOutput [ ThreadID.x ] = B;
}