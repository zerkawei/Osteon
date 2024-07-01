using System;
namespace Osteon;

[UnderlyingArray(typeof(float), 4, true)]
public struct Quaternion
{
	public static Self Identity = .(0,0,0,1);

	public float X;
	public float Y;
	public float Z;
	public float W;

	[Inline]
	public float Norm => Math.Sqrt(NormSquared);
	public float NormSquared => X*X + Y*Y + Z*Z + W*W;

	public Self Conjugate => .(-X, -Y, -Z, W);

	public this(float x, float y, float z, float w)
	{
		X = x;
		Y = y;
		Z = z;
		W = w;
	}

	public static Self Euler(Vector3 euler)
 	{
		 let e = euler / 2;
		 let s = Vector3(Math.Sin(e.X), Math.Sin(e.Y), Math.Sin(e.Z));
		 let c = Vector3(Math.Cos(e.X), Math.Cos(e.Y), Math.Cos(e.Z));

		 return .(
			 s.Z*c.Y*c.X-c.Z*s.Y*s.X,
			 c.Z*s.Y*c.X+s.Z*c.Y*s.X,
			 c.Z*c.Y*s.X-s.Z*s.Y*c.X,
			 c.Z*c.Y*c.X+s.Z*s.Y*s.X
		 );
	}

	public Vector3 Rotate(Vector3 v) => (.)((this * v) * Conjugate);

	[ElementWise("+")]             public static Self operator+(Self lhs, Self rhs)  {}
	[ElementWise("+"), Commutable] public static Self operator+(Self lhs, float rhs) {}
	[ElementWise("-")]             public static Self operator-(Self lhs)            {}
	[ElementWise("-")]             public static Self operator-(Self lhs, Self rhs)  {}
	[ElementWise("-"), Commutable] public static Self operator-(Self lhs, float rhs) {}
	[ElementWise("*"), Commutable] public static Self operator*(Self lhs, float rhs) {}
	[ElementWise("/")]             public static Self operator/(Self lhs, float rhs) {}
	[ElementWise("==", "&&")]      public static bool operator==(Self lhs, Self rhs) {}
	[ElementWise("!=", "||")]      public static bool operator!=(Self lhs, Self rhs) {}

	public static Self operator*(Self lhs, Self rhs)
		=> .(
			lhs.W * rhs.X + lhs.X * rhs.Y + lhs.Y * rhs.Z - lhs.Z * rhs.W,
			lhs.W * rhs.Y + lhs.X * rhs.Z + lhs.Y * rhs.W - lhs.Z * rhs.X,
			lhs.W * rhs.Z + lhs.X * rhs.W + lhs.Y * rhs.X - lhs.Z * rhs.Y,
			lhs.W * rhs.W - lhs.X * rhs.X - lhs.Y * rhs.Y - lhs.Z * rhs.Z
		);

	public static implicit operator Self(Vector3 v) => .(v.X, v.Y, v.Z, 0);
	public static explicit operator Vector3(Self q) => .(q.X, q.Y, q.Z);
}