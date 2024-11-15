using System;
namespace Osteon;

[UnderlyingArray(typeof(float), 3, true), Align(16)]
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

	[Intrinsic("add")]
	public static extern Self operator+(Self lhs, Self rhs);
	[Intrinsic("add"), Commutable]
	public static extern Self operator+(Self lhs, float rhs);
	[Intrinsic("add")]
	public static extern Self operator++(Self lhs);

	[Intrinsic("sub")]
	public static extern Self operator-(Self lhs, Self rhs);
	[Intrinsic("sub"), Commutable]
	public static extern Self operator-(Self lhs, float rhs);
	[Intrinsic("sub")]
	public static extern Self operator--(Self lhs);

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

	public static explicit operator Vector4(Self vec) => .(vec.X, vec.Y, vec.Z, 1f);
	public static explicit operator Self(Vector4 vec) => *(Self*)&vec;

	public override void ToString(String strBuffer) => strBuffer.AppendF("[{} {} {}]", X, Y, Z);
}