using System;
using System.Numerics;
namespace Osteon;

[Union]
public struct Vector3
{
	public const Self One = .(1);
	public const Self Zero = .(0);

	public const Self UnitX = .(1,0,0);
	public const Self UnitY = .(0,1,0);
	public const Self UnitZ = .(0,0,1);

	private float[3] vals;
	public struct
	{
		public float X;
		public float Y;
		public float Z;
	};

	public float this[int i]
	{
		[Inline] get => vals[i];
		[Inline] set mut => vals[i] = value;
	}

	[Inline]
	public this(float val) : this(val, val, val) {}

	[Inline]
	public this(float x, float y, float z)
	{
		vals = ?;
		vals[0] = x;
		vals[1] = y;
		vals[2] = z;
	}

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

	[Inline]
	public static Self Max(Self lhs, Self rhs) => float4.max((.)lhs, (.)rhs);
	[Inline]
	public static Self Min(Self lhs, Self rhs) => float4.min((.)lhs, (.)rhs);

	[Inline]
	public static Self operator+(Self lhs, Self rhs) => (float4)lhs + (float4)rhs;
	[Inline, Commutable]
	public static Self operator+(Self lhs, float rhs) => (float4)lhs + rhs;

	[Inline]
	public static Self operator-(Self lhs, Self rhs) => (float4)lhs - (float4)rhs;
	[Inline]
	public static Self operator-(Self lhs, float rhs) => (float4)lhs - rhs;
	[Inline]
	public static Self operator-(float lhs, Self rhs) => lhs - (float4)rhs;

	[Inline]
	public static Self operator*(Self lhs, Self rhs) => (float4)lhs * (float4)rhs;
	[Inline, Commutable]
	public static Self operator*(Self lhs, float rhs) => (float4)lhs * rhs;

	[Inline]
	public static Self operator/(Self lhs, Self rhs) => (float4)lhs / (float4)rhs;
	[Inline]
	public static Self operator/(Self lhs, float rhs) => (float4)lhs / rhs;
	[Inline]
	public static Self operator/(float lhs, Self rhs) => lhs / (float4)rhs;

	public static bool operator > (Self lhs, Self rhs) => lhs.X >  rhs.X && lhs.Y >  rhs.Y && lhs.Z >  rhs.Z;
	public static bool operator >=(Self lhs, Self rhs) => lhs.X >= rhs.X && lhs.Y >= rhs.Y && lhs.Z >= rhs.Z;
	public static bool operator < (Self lhs, Self rhs) => lhs.X <  rhs.X && lhs.Y <  rhs.Y && lhs.Z <  rhs.Z;
	public static bool operator <=(Self lhs, Self rhs) => lhs.X <= rhs.X && lhs.Y <= rhs.Y && lhs.Z <= rhs.Z;
	public static bool operator ==(Self lhs, Self rhs) => lhs.X == rhs.X && lhs.Y == rhs.Y && lhs.Z == rhs.Z;

	[Inline]
	public static Self operator implicit(float4 vec) => .(vec.x, vec.y, vec.z);
	[Inline]
	public static float4 operator explicit(Self vec) => .(vec.X, vec.Y, vec.Z, 1f);
	[Inline]
	public static Self operator implicit(Vector4 vec) => .(vec.X, vec.Y, vec.Z);
	[Inline]
	public static Vector4 operator explicit(Self vec) => .(vec.X, vec.Y, vec.Z, 1f);

	public override void ToString(String strBuffer) => strBuffer.AppendF("[{} {} {}]", X, Y, Z);
}