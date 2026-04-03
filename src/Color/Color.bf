using System;
using System.Numerics;
namespace Osteon.Color;

public struct Color
{
	public float R;
	public float G;
	public float B;
	public float A;

	public this(float r, float g, float b, float a = 1f)
	{
		R = r;
		G = g;
		B = b;
		A = a;
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

	[Inline]
	public static bool operator ==(Self lhs, Self rhs) => lhs.R == rhs.R && lhs.G == rhs.G && lhs.B == rhs.B && lhs.A == rhs.A;

	[Inline]
	public static Self operator implicit(float4 vec) => .(vec.x, vec.y, vec.z, vec.w);
	[Inline]
	public static float4 operator explicit(Self vec) => .(vec.R, vec.G, vec.B, vec.A);
}