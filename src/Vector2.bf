using System;
using System.Numerics;
namespace Osteon;

[Union]
public struct Vector2
{
	public const Self One = .(1);
	public const Self Zero = .(0);

	public const Self UnitX = .(1,0);
	public const Self UnitY = .(0,1);

	private float[2] vals;
	public struct
	{
		public float X;
		public float Y;
	};

	public float this[int i]
	{
		[Inline] get => vals[i];
		[Inline] set mut => vals[i] = value;
	}

	[Inline]
	public this(float val) : this(val, val) {}

	[Inline]
	public this(float x, float y)
	{
		vals = ?;
		vals[0] = x;
		vals[1] = y;
	}

	[Inline]
	public static Self FromAngle(float angle) => .(Math.Sin(angle), Math.Cos(angle));
	[Inline]
	public float Angle => Math.Atan2(this.Y, this.X);

	[Inline]
	public float LengthSquared => Dot(this, this);
	[Inline]
	public float Length => Math.Sqrt(Dot(this, this));
	[Inline]
	public Self Normalized => this/Length;

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
	public static Self Max(Self lhs, Self rhs)
	{
		let max = float4.max(.(lhs.X, lhs.Y, rhs.X, rhs.Y), .(rhs.X, rhs.Y, lhs.X, lhs.Y));
		return .(max.x, max.y);
	}
	[Inline]
	public static Self Min(Self lhs, Self rhs)
	{
		let min = float4.min(.(lhs.X, lhs.Y, 1f, 1f), .(rhs.X, rhs.Y, 1f, 1f));
		return .(min.x, min.y);
	} 

	[Inline]
	public static Self operator+(Self lhs, Self rhs) => (float2)lhs + (float2)rhs;
	[Inline, Commutable]
	public static Self operator+(Self lhs, float rhs) => (float2)lhs + rhs;

	[Inline]
	public static Self operator-(Self lhs, Self rhs) => (float2)lhs - (float2)rhs;
	[Inline]
	public static Self operator-(Self lhs, float rhs) => (float2)lhs - rhs;
	[Inline]
	public static Self operator-(float lhs, Self rhs) => lhs - (float2)rhs;

	[Inline]
	public static Self operator*(Self lhs, Self rhs) => (float2)lhs * (float2)rhs;
	[Inline, Commutable]
	public static Self operator*(Self lhs, float rhs) => (float2)lhs * rhs;

	[Inline]
	public static Self operator/(Self lhs, Self rhs) => (float2)lhs / (float2)rhs;
	[Inline]
	public static Self operator/(Self lhs, float rhs) => (float2)lhs / rhs;
	[Inline]
	public static Self operator/(float lhs, Self rhs) => lhs / (float2)rhs;

	public static bool operator > (Self lhs, Self rhs) => lhs.X >  rhs.X && lhs.Y >  rhs.Y;
	public static bool operator >=(Self lhs, Self rhs) => lhs.X >= rhs.X && lhs.Y >= rhs.Y;
	public static bool operator < (Self lhs, Self rhs) => lhs.X <  rhs.X && lhs.Y <  rhs.Y;
	public static bool operator <=(Self lhs, Self rhs) => lhs.X <= rhs.X && lhs.Y <= rhs.Y;
	public static bool operator ==(Self lhs, Self rhs) => lhs.X == rhs.X && lhs.Y == rhs.Y;

	[Inline]
	public static Self operator implicit(float2 vec) => .(vec.x, vec.y);
	[Inline]
	public static float2 operator explicit(Self vec) => .(vec.X, vec.Y);
	[Inline]
	public static Self operator implicit(Vector3 vec) => .(vec.X, vec.Y);
	[Inline]
	public static Vector3 operator explicit(Self vec) => .(vec.X, vec.Y, 1f);

	public override void ToString(String strBuffer) => strBuffer.AppendF("[{} {}]", X, Y);
}