using System;
using System.Numerics;
namespace Osteon;

[Union]
public struct Point3D
{
	public const Self One = .(1);
	public const Self Zero = .(0);

	public const Self UnitX = .(1,0,0);
	public const Self UnitY = .(0,1,0);
	public const Self UnitZ = .(0,0,1);

	private int32[3] vals;
	public struct
	{
		public int32 X;
		public int32 Y;
		public int32 Z;
	};

	public int32 this[int i]
	{
		[Inline] get => vals[i];
		[Inline] set mut => vals[i] = value;
	}

	[Inline]
	public this(int32 val) : this(val, val, val) {}

	[Inline]
	public this(int32 x, int32 y, int32 z)
	{
		vals = ?;
		vals[0] = x;
		vals[1] = y;
		vals[2] = z;
	}

	public float LengthSquared => Dot(this, this);
	public float Length => Math.Sqrt(Dot(this, this));
	public Vector3 Normalized => ((.)this)/Length;

	public float DistanceSquared(Self other) => (this - other).LengthSquared;
	public float Distance(Self other) => (this - other).Length;

	public float Dot(Self other) => Dot(this, other);
	public static float Dot(Self lhs, Self rhs)
	{
		let c = lhs * rhs;
		return c.X + c.Y + c.Z;
	}

	[Inline]
	public static Self operator+(Self lhs, Self rhs) => (int32_4)lhs + (int32_4)rhs;
	[Inline, Commutable]
	public static Self operator+(Self lhs, int32 rhs) => (int32_4)lhs + rhs;

	[Inline]
	public static Self operator-(Self lhs, Self rhs) => (int32_4)lhs - (int32_4)rhs;
	[Inline]
	public static Self operator-(Self lhs, int32 rhs) => (int32_4)lhs - rhs;
	[Inline]
	public static Self operator-(int32 lhs, Self rhs) => lhs - (int32_4)rhs;

	[Inline]
	public static Self operator*(Self lhs, Self rhs) => (int32_4)lhs * (int32_4)rhs;
	[Inline, Commutable]
	public static Self operator*(Self lhs, int32 rhs) => (int32_4)lhs * rhs;

	[Inline]
	public static Self operator/(Self lhs, Self rhs) => (int32_4)lhs / (int32_4)rhs;
	[Inline]
	public static Self operator/(Self lhs, int32 rhs) => (int32_4)lhs / rhs;
	[Inline]
	public static Self operator/(int32 lhs, Self rhs) => lhs / (int32_4)rhs;

	public static bool operator > (Self lhs, Self rhs) => lhs.X >  rhs.X && lhs.Y >  rhs.Y && lhs.Z >  rhs.Z;
	public static bool operator >=(Self lhs, Self rhs) => lhs.X >= rhs.X && lhs.Y >= rhs.Y && lhs.Z >= rhs.Z;
	public static bool operator < (Self lhs, Self rhs) => lhs.X <  rhs.X && lhs.Y <  rhs.Y && lhs.Z <  rhs.Z;
	public static bool operator <=(Self lhs, Self rhs) => lhs.X <= rhs.X && lhs.Y <= rhs.Y && lhs.Z <= rhs.Z;
	public static bool operator ==(Self lhs, Self rhs) => lhs.X == rhs.X && lhs.Y == rhs.Y && lhs.Z == rhs.Z;

	[Inline]
	public static Self operator implicit(int32_4 vec) => .(vec.x, vec.y, vec.z);
	[Inline]
	public static int32_4 operator explicit(Self vec) => .(vec.X, vec.Y, vec.Z, 1);
	[Inline]
	public static Self operator implicit(Vector3 vec) => .((.)vec.X, (.)vec.Y, (.)vec.Z);
	[Inline]
	public static Vector3 operator explicit(Self vec) => .(vec.X, vec.Y, vec.Z);

	public override void ToString(String strBuffer) => strBuffer.AppendF("[{} {} {}]", X, Y, Z);
}