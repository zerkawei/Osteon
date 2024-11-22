using System;
namespace Osteon.Color;

[UnderlyingArray(typeof(float), 4, true)]
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
}