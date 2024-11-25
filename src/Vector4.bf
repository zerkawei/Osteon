using System;
using System.Numerics;
namespace Osteon;

[UnderlyingArray(typeof(float), 4, true)]
public struct Vector4
{
	public const Self UnitX = .(1,0,0,0);
	public const Self UnitY = .(0,1,0,0);
	public const Self UnitZ = .(0,0,1,0);
	public const Self UnitW = .(0,0,0,1);

	public float X;
	public float Y;
	public float Z;
	public float W;

	public this(float val) : this(val, val, val, val) {}
	public this(float x, float y, float z, float w)
	{
		X = x;
		Y = y;
		Z = z;
		W = w;
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
		return c.X + c.Y + c.Z + c.W;
	}

	public static Self Max(Self lhs, Self rhs)
	{
		let res = float4.max(*(float4*)&lhs, *(float4*)&rhs);
		return *(Self*)&res;
	}

	public static Self Min(Self lhs, Self rhs)
	{
		float4 res = .min(*(float4*)&lhs, *(float4*)&rhs);
		return *(Self*)&res;
	}

	[Intrinsic("add")]
	public static extern Self operator+(Self lhs, Self rhs);
	[Intrinsic("add"), Commutable]
	public static extern Self operator+(Self lhs, float rhs);

	[Intrinsic("sub")]
	public static extern Self operator-(Self lhs, Self rhs);
	[Intrinsic("sub"), Commutable]
	public static extern Self operator-(Self lhs, float rhs);

	[Intrinsic("mul")]
	public static extern Self operator*(Self lhs, Self rhs);
	[Intrinsic("mul"), Commutable]
	public static extern Self operator*(Self lhs, float rhs);

	[Intrinsic("div")]
	public static extern Self operator/(Self lhs, Self rhs);
	[Intrinsic("div")]
	public static extern Self operator/(Self lhs, float rhs);
	[Intrinsic("div")]
	public static extern Self operator/(float lhs, Self rhs);

	public override void ToString(String strBuffer) => strBuffer.AppendF("[{} {} {} {}]", X, Y, Z, W);
}