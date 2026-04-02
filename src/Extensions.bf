namespace System.Numerics;

public extension float4
{
	public static implicit operator float4(float[4] vec) => .(vec[0], vec[1], vec[2], vec[3]);
	public static implicit operator float4(float[3] vec) => .(vec[0], vec[1], vec[2], 1f);
}

public extension float2
{
	public static implicit operator float2(float[2] vec) => .(vec[0], vec[1]);
}