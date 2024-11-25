using System;
using System.Numerics;
namespace Osteon;

[UnderlyingArray(typeof(int32), 3, true)]
public struct Point3D
{
	public const Self UnitX = .(1,0,0);
	public const Self UnitY = .(0,1,0);
	public const Self UnitZ = .(0,0,1);

	public int32 X;
	public int32 Y;
	public int32 Z;

	public this(int32 val) : this(val, val, val) {}
	public this(int32 x, int32 y, int32 z)
	{
		X = x;
		Y = y;
		Z = z;
	}

	public extern float this[int idx] { [Intrinsic("index")] get; [Intrinsic("index")] set; }

	public float LengthSquared => Dot(this, this);
	public float Length => Math.Sqrt(Dot(this, this));

	public float DistanceSquared(Self other) => (this - other).LengthSquared;
	public float Distance(Self other) => (this - other).Length;

	public float Dot(Self other) => Dot(this, other);
	public static float Dot(Self lhs, Self rhs)
	{
		let c = lhs * rhs;
		return c.X + c.Y + c.Z;
	}

	public static Self operator+(Self lhs, Self rhs)
	{
		int32_4 res = *(int32_4*)&lhs + *(int32_4*)&rhs;
		return .(res.x, res.y, res.z);
	}
	public static Self operator+(Self lhs, int32 rhs)
	{
		int32_4 res = *(int32_4*)&lhs + .(rhs,rhs,rhs,rhs);
		return .(res.x, res.y, res.z);
	}

	public static Self operator-(Self lhs, Self rhs)
	{
		int32_4 res = *(int32_4*)&lhs - *(int32_4*)&rhs;
		return .(res.x, res.y, res.z);
	}
	public static Self operator-(Self lhs, int32 rhs)
	{
		int32_4 res = *(int32_4*)&lhs - .(rhs,rhs,rhs,rhs);
		return .(res.x, res.y, res.z);
	}

	public static Self operator*(Self lhs, Self rhs)
	{
		int32_4 res = *(int32_4*)&lhs * *(int32_4*)&rhs;
		return .(res.x, res.y, res.z);
	}
	[Commutable]
	public static Self operator*(Self lhs, int32 rhs)
	{
		int32_4 res = *(int32_4*)&lhs * .(rhs,rhs,rhs,rhs);
		return .(res.x, res.y, res.z);
	}

	public static Self operator/(Self lhs, Self rhs)
	{
		int32_4 res = *(int32_4*)&lhs / *(int32_4*)&rhs;
		return .(res.x, res.y, res.z);
	}
	public static Self operator/(Self lhs, int32 rhs)
	{
		int32_4 res = *(int32_4*)&lhs / .(rhs,rhs,rhs,rhs);
		return .(res.x, res.y, res.z);
	}
	public static Self operator/(int32 lhs, Self rhs)
	{
		int32_4 res = .(lhs,lhs,lhs,lhs) / *(int32_4*)&rhs;
		return .(res.x, res.y, res.z);
	}

	public static explicit operator Vector3(Self vec) => .(vec.X, vec.Y, vec.Z);
	public static explicit operator Self(Vector3 vec) => .((.)vec.X, (.)vec.Y, (.)vec.Z);

	public override void ToString(String strBuffer) => strBuffer.AppendF("[{} {} {}]", X, Y, Z);
}