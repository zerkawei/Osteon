using System;
using System.Numerics;
namespace Osteon;

[UnderlyingArray(typeof(float), 3, true)]
public struct Vector3
{
	public const Self UnitX = .(1,0,0);
	public const Self UnitY = .(0,1,0);
	public const Self UnitZ = .(0,0,1);

	public float X;
	public float Y;
	public float Z;

	public this(float val) : this(val, val, val) {}
	public this(float x, float y, float z)
	{
		X = x;
		Y = y;
		Z = z;
	}

	public extern float this[int idx] { [Intrinsic("index")] get; [Intrinsic("index")] set; }

	public float LengthSquared => Dot(this, this);
	public float Length => Math.Sqrt(Dot(this, this));
	public Self Normalized => this/Length;

	public float DistanceSquared(Self other) => (this - other).LengthSquared;
	public float Distance(Self other) => (this - other).Length;

	public float Dot(Self other) => Dot(this, other);
	public static float Dot(Self lhs, Self rhs)
	{
		let c = lhs * rhs;
		return c.X + c.Y + c.Z;
	}

	public static Self Max(Self lhs, Self rhs)
	{
		float4 res = .max(*(float4*)&lhs, *(float4*)&rhs);
		return .(res.x, res.y, res.z);
	}

	public static Self Min(Self lhs, Self rhs)
	{
		float4 res = .min(*(float4*)&lhs, *(float4*)&rhs);
		return .(res.x, res.y, res.z);
	}

	public static Self operator+(Self lhs, Self rhs)
	{
		float4 res = *(float4*)&lhs + *(float4*)&rhs;
		return .(res.x, res.y, res.z);
	}
	public static Self operator+(Self lhs, float rhs)
	{
		float4 res = *(float4*)&lhs + .(rhs,rhs,rhs,rhs);
		return .(res.x, res.y, res.z);
	}

	public static Self operator-(Self lhs, Self rhs)
	{
		float4 res = *(float4*)&lhs - *(float4*)&rhs;
		return .(res.x, res.y, res.z);
	}
	public static Self operator-(Self lhs, float rhs)
	{
		float4 res = *(float4*)&lhs - .(rhs,rhs,rhs,rhs);
		return .(res.x, res.y, res.z);
	}

	public static Self operator*(Self lhs, Self rhs)
	{
		float4 res = *(float4*)&lhs * *(float4*)&rhs;
		return .(res.x, res.y, res.z);
	}
	[Commutable]
	public static Self operator*(Self lhs, float rhs)
	{
		float4 res = *(float4*)&lhs * .(rhs,rhs,rhs,rhs);
		return .(res.x, res.y, res.z);
	}

	public static Self operator/(Self lhs, Self rhs)
	{
		float4 res = *(float4*)&lhs / *(float4*)&rhs;
		return .(res.x, res.y, res.z);
	}
	public static Self operator/(Self lhs, float rhs)
	{
		float4 res = *(float4*)&lhs / .(rhs,rhs,rhs,rhs);
		return .(res.x, res.y, res.z);
	}
	public static Self operator/(float lhs, Self rhs)
	{
		float4 res = .(lhs,lhs,lhs,lhs) / *(float4*)&rhs;
		return .(res.x, res.y, res.z);
	}

	public static explicit operator Vector4(Self vec) => .(vec.X, vec.Y, vec.Z, 1f);
	public static explicit operator Self(Vector4 vec) => *(Self*)&vec;

	public override void ToString(String strBuffer) => strBuffer.AppendF("[{} {} {}]", X, Y, Z);
}