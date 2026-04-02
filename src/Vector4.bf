using System;
using System.Numerics;
namespace Osteon;

[Union]
public struct Vector4
{
	public const Self One = .(1);
	public const Self Zero = .(0);

	public const Self UnitX = .(1,0,0,0);
	public const Self UnitY = .(0,1,0,0);
	public const Self UnitZ = .(0,0,1,0);
	public const Self UnitW = .(0,0,0,1);

	private float[4] vals;
	public struct
	{
		public float X;
		public float Y;
		public float Z;
		public float W;
	};

	public float this[int i]
	{
		[Inline] get => vals[i];
		[Inline] set mut => vals[i] = value;
	}

	[Inline]
	public this(float val) : this(val, val, val, val) {}

	[Inline]
	public this(float x, float y, float z, float w)
	{
		vals = ?;
		vals[0] = x;
		vals[1] = y;
		vals[2] = z;
		vals[3] = w;
	}

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
		return c.X + c.Y + c.Z + c.W;
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

	public static bool operator > (Self lhs, Self rhs) => lhs.X >  rhs.X && lhs.Y >  rhs.Y && lhs.Z >  rhs.Z && lhs.W >  rhs.W;
	public static bool operator >=(Self lhs, Self rhs) => lhs.X >= rhs.X && lhs.Y >= rhs.Y && lhs.Z >= rhs.Z && lhs.W >= rhs.W;
	public static bool operator < (Self lhs, Self rhs) => lhs.X <  rhs.X && lhs.Y <  rhs.Y && lhs.Z <  rhs.Z && lhs.W <  rhs.W;
	public static bool operator <=(Self lhs, Self rhs) => lhs.X <= rhs.X && lhs.Y <= rhs.Y && lhs.Z <= rhs.Z && lhs.W <= rhs.W;
	public static bool operator ==(Self lhs, Self rhs) => lhs.X == rhs.X && lhs.Y == rhs.Y && lhs.Z == rhs.Z && lhs.W == rhs.W;

	[Inline]
	public static Self operator implicit(float4 vec) => .(vec.x, vec.y, vec.z, vec.w);
	[Inline]
	public static float4 operator explicit(Self vec) => .(vec.X, vec.Y, vec.Z, vec.W);

	public override void ToString(String strBuffer) => strBuffer.AppendF("[{} {} {} {}]", X, Y, Z, W);
}