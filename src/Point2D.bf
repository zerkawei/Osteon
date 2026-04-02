using System;
using System.Numerics;
namespace Osteon;

[Union]
public struct Point2D
{
	public const Self One = .(1);
	public const Self Zero = .(0);

	public const Self UnitX = .(1,0);
	public const Self UnitY = .(0,1);

	private int32[2] vals;
	public struct
	{
		public int32 X;
		public int32 Y;
	};

	public int32 this[int i]
	{
		[Inline] get => vals[i];
		[Inline] set mut => vals[i] = value;
	}

	[Inline]
	public this(int32 val) : this(val, val) {}

	[Inline]
	public this(int32 x, int32 y)
	{
		vals = ?;
		vals[0] = x;
		vals[1] = y;
	}

	[Inline]
	public float Angle => Math.Atan2(this.Y, this.X);

	[Inline]
	public float LengthSquared => Dot(this, this);
	[Inline]
	public float Length => Math.Sqrt(Dot(this, this));
	[Inline]
	public Vector2 Normalized => ((.)this)/Length;

	[Inline]
	public float DistanceSquared(Self other) => (this - other).LengthSquared;
	[Inline]
	public float Distance(Self other) => (this - other).Length;

	[Inline]
	public float Dot(Self other) => Dot(this, other);
	[Inline]
	public static float Dot(Self lhs, Self rhs)
	{
		let c = lhs * rhs;
		return c.X + c.Y;
	}

	[Inline]
	public static Self operator+(Self lhs, Self rhs) => .(lhs.X + rhs.X, lhs.Y + rhs.Y);
	[Inline, Commutable]
	public static Self operator+(Self lhs, int32 rhs) => .(lhs.X + rhs, lhs.Y + rhs);

	[Inline]
	public static Self operator-(Self lhs, Self rhs) => .(lhs.X - rhs.X, lhs.Y - rhs.Y);
	[Inline]
	public static Self operator-(Self lhs, int32 rhs) => .(lhs.X - rhs, lhs.Y - rhs);
	[Inline]
	public static Self operator-(int32 lhs, Self rhs) => .(lhs - rhs.X, lhs - rhs.Y);

	[Inline]
	public static Self operator*(Self lhs, Self rhs) => .(lhs.X * rhs.X, lhs.Y * rhs.Y);
	[Inline, Commutable]
	public static Self operator*(Self lhs, int32 rhs) => .(lhs.X * rhs, lhs.Y * rhs);

	[Inline]
	public static Self operator/(Self lhs, Self rhs) => .(lhs.X / rhs.X, lhs.Y + rhs.Y);
	[Inline]
	public static Self operator/(Self lhs, int32 rhs) => .(lhs.X / rhs, lhs.Y / rhs);
	[Inline]
	public static Self operator/(int32 lhs, Self rhs) => .(lhs / rhs.X, lhs / rhs.Y);

	public static bool operator > (Self lhs, Self rhs) => lhs.X >  rhs.X && lhs.Y >  rhs.Y;
	public static bool operator >=(Self lhs, Self rhs) => lhs.X >= rhs.X && lhs.Y >= rhs.Y;
	public static bool operator < (Self lhs, Self rhs) => lhs.X <  rhs.X && lhs.Y <  rhs.Y;
	public static bool operator <=(Self lhs, Self rhs) => lhs.X <= rhs.X && lhs.Y <= rhs.Y;
	public static bool operator ==(Self lhs, Self rhs) => lhs.X == rhs.X && lhs.Y == rhs.Y;

	[Inline]
	public static Self operator implicit(Vector2 vec) => .((.)vec.X, (.)vec.Y);
	[Inline]
	public static Vector2 operator explicit(Self vec) => .(vec.X, vec.Y);
	[Inline]
	public static Self operator implicit(Point3D vec) => .(vec.X, vec.Y);
	[Inline]
	public static Point3D operator explicit(Self vec) => .(vec.X, vec.Y, 1);

	public override void ToString(String strBuffer) => strBuffer.AppendF("[{} {}]", X, Y);
}