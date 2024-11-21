using System;
using System.Numerics;
namespace Osteon.Transform;

public struct Quaternion
{
	public const Self Identity = .(0,0,0,1);

	public float X;
	public float Y;
	public float Z;
	public float W;

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

	[Inline]
	public float Norm => Math.Sqrt(NormSquared);
	public float NormSquared => X*X + Y*Y + Z*Z + W*W;

	public Self Conjugate => .(-X, -Y, -Z, W);

	public Vector3 Rotate(Vector3 v) => (.)((this * v) * Conjugate);

	public static Self operator*(Self lhs, Self rhs)
	{
		float4 res = .( lhs.X,  lhs.X,  lhs.X, -lhs.X) * .(rhs.Y, rhs.Z, rhs.W, rhs.X)
			       + .( lhs.Y,  lhs.Y,  lhs.Y, -lhs.Y) * .(rhs.Z, rhs.W, rhs.X, rhs.Y)
			       + .(-lhs.Z, -lhs.Z, -lhs.Z, -lhs.Z) * .(rhs.W, rhs.X, rhs.Y, rhs.Z)
			       + .( lhs.W,  lhs.W,  lhs.W, -lhs.W) * .(rhs.X, rhs.Y, rhs.Z, rhs.W);

		return *(Self*)&res;
	}
	
	public static implicit operator Self(Vector3 v) => .(v.X, v.Y, v.Z, 0);
	public static explicit operator Vector3(Self q) => .(q.X, q.Y, q.Z);

	public static implicit operator Matrix4(Self q)
	{
		let s  = 2f / q.NormSquared;
		let q2 = (Vector3)q * (Vector3)q;
		let xy = q.X * q.Y;
		let zw = q.Z * q.W;
		let xz = q.X * q.Z;
		let yw = q.Y * q.W;
		let yz = q.Y * q.Z;
		let xw = q.X * q.W;

		return .(
			1-s*(q2.Y + q2.Z), s*(xy - zw), s*(xz + yw), 0,
			s*(xy + zw), 1-s*(q2.X + q2.Z), s*(yz - xw), 0,
			s*(xz - yw), s*(yz + xw), 1-s*(q2.X + q2.Y), 0,
			0, 0, 0, 1
			);
	}

	public static implicit operator Transform3D(Self q)
	{
		let s  = 2f / q.NormSquared;
		let q2 = (Vector3)q * (Vector3)q;
		let xy = q.X * q.Y;
		let zw = q.Z * q.W;
		let xz = q.X * q.Z;
		let yw = q.Y * q.W;
		let yz = q.Y * q.Z;
		let xw = q.X * q.W;

		return .(
			1-s*(q2.Y + q2.Z), s*(xy - zw), s*(xz + yw), 0,
			s*(xy + zw), 1-s*(q2.X + q2.Z), s*(yz - xw), 0,
			s*(xz - yw), s*(yz + xw), 1-s*(q2.X + q2.Y), 0
			);
	}

}