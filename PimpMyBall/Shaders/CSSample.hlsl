struct VERTEXPROPERTIES
{
	float4 Vertices; 
	float4 Normals; 
	float	u, 
			v;
};

struct VERTEX 
{
	VERTEXPROPERTIES vVtx; 
};

cbuffer MATRIX4D
{
	matrix Transform; 
};

StructuredBuffer<VERTEX> Input:register( t0 );  
RWStructuredBuffer<VERTEX> Output:register( u0 ); 

[numthreads(1,1,1)]

void CSMain ( uint3 ThreadID: SV_DispatchThreadID ) 
{
	VERTEX V; 

	V = Input [ ThreadID.x ]; 
	V.vVtx.Vertices = mul ( V.vVtx.Vertices, Transform ); 
	
	Output [ ThreadID.x ] = V; 
}