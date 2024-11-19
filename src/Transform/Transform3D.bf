using System;
using System.Numerics;
namespace Osteon.Transform;

public struct Transform3D
{
	public const Self Identity = .(1,0,0,0,
								   0,1,0,0,
		                           0,0,1,0);

#if OSTEON_COLUMN_MAJOR
	private float[4][3] mVals;
#else
	private float[3][4] mVals;
#endif

	public this(float m00, float m01, float m02, float m03, float m10, float m11, float m12, float m13, float m20, float m21, float m22, float m23)
	{
#if OSTEON_COLUMN_MAJOR
		mVals = .(.(m00, m10, m20), .(m01, m11, m21), .(m02, m12, m22), .(m03, m13, m23));
#else
		mVals = .(.(m00, m01, m02, m03), .(m10, m11, m12, m13), .(m20, m21, m22, m23));
#endif
	}

	public static Self Translate(Vector3 by) => .(1,0,0,by.X,
											      0,1,0,by.Y,
												  0,0,1,by.Z);

	public static Self Scale(Vector3 by) => .(by.X,0,0,0,
		                                      0,by.Y,0,0,
											  0,0,by.Z,0);

	public static Self Scale(float by) => .(by,0,0,0,
		                                    0,by,0,0,
											0,0,by,0);

	public static Self Rotate(Vector3 axis, float angle)
	{
		let s  = Math.Sin(angle) * axis;
		let c  = Math.Cos(angle);
		let ic = (1-c)*axis;
		let xx = axis.X * ic.X;
		let xy = axis.X * ic.Y;
		let yy = axis.Y * ic.Y;
		let yz = axis.Y * ic.Z;
		let zz = axis.Z * ic.Z;
		let zx = axis.Z * ic.X;
		return .(xx + c,   xy - s.Z, zx + s.Y, 0,
			     xy + s.Z, yy + c,   yz - s.X, 0,
				 zx - s.Y, yz + s.X, zz + c,   0);
	}

	public float this[int row, int col]
	{
#if OSTEON_COLUMN_MAJOR
		[Inline] get     => mVals[col][row];
		[Inline] set mut => mVals[col][row] = value;
#else
		[Inline] get     => mVals[row][col];
		[Inline] set mut => mVals[row][col] = value;
#endif
	}

	public float Determinant
	{
		[DisableChecks, Optimize]
		get
		{
			float4 tmp = .(this[0,0], this[0,1], this[0,2], 0) * .(this[1,1], this[1,2], this[1,0], 0) * .(this[2,2], this[2,0], this[2,1], 0)
				       - .(this[0,2], this[0,1], this[0,0], 0) * .(this[1,1], this[1,0], this[1,2], 0) * .(this[2,0], this[2,2], this[2,1], 0);
			return tmp.x + tmp.y + tmp.z;
		}
	}

	[DisableChecks, Optimize]
	public static Vector3 operator*(Self a, Vector3 b)
	{
#if OSTEON_COLUMN_MAJOR
		float4 tmp = float4(b.X,b.X,b.X,b.X) * *(float4*)&a.mVals[0]
			       + float4(b.Y,b.Y,b.Y,b.Y) * *(float4*)&a.mVals[1]
			       + float4(b.Z,b.Z,b.Z,b.Z) * *(float4*)&a.mVals[2]
				   + (float4*)&a.mVals[3];

		return *(Vector3*)&tmp;
#else
		Vector3 res = ?;

		float4 tmp = .(b.X,b.Y,b.Z,1) * *(float4*)&a.mVals[0];
		res.X = tmp.x + tmp.y + tmp.z + tmp.w;

		tmp = .(b.X,b.Y,b.Z,1) * *(float4*)&a.mVals[1];
		res.Y = tmp.x + tmp.y + tmp.z + tmp.w;

		tmp = .(b.X,b.Y,b.Z,1) * *(float4*)&a.mVals[2];
		res.Z = tmp.x + tmp.y + tmp.z + tmp.w;
		return res;
#endif
	}

	[DisableChecks, Optimize]
	public static Self operator*(Self a, Self b)
	{
		Self res = ?;
#if OSTEON_COLUMN_MAJOR
		for(let i < 4)
		{
			float4 col = .(b[0,i],b[0,i],b[0,i],b[0,i]) * [Inline]BitConverter.Convert<?,float4>(a.mVals[0])
					   + .(b[1,i],b[1,i],b[1,i],b[1,i]) * [Inline]BitConverter.Convert<?,float4>(a.mVals[1])
					   + .(b[2,i],b[2,i],b[2,i],b[2,i]) * [Inline]BitConverter.Convert<?,float4>(a.mVals[2]);
			if(i == 3) col += [Inline]BitConverter.Convert<?,float4>(a.mVals[3]);
			res.mVals[i] = *(float[4]*)&col;
		}
		return res;
#else
		for(let i < 3)
		{
			float4 row = .(a[i,0],a[i,0],a[i,0],a[i,0]) * *(float4*)&b.mVals[0]
					   + .(a[i,1],a[i,1],a[i,1],a[i,1]) * *(float4*)&b.mVals[1]
					   + .(a[i,2],a[i,2],a[i,2],a[i,2]) * *(float4*)&b.mVals[2];
			res.mVals[i] = .(row.x, row.y, row.z, row.w + a[i,3]);
		}
#endif
		return res;
	}

	public static explicit operator Matrix4(Self m) => .(m[0,0],m[0,1],m[0,2],m[0,3],m[1,0],m[1,1],m[1,2],m[1,3],m[2,0],m[2,1],m[2,2],m[2,3],0,0,0,1);
	public override void ToString(String strBuffer) => strBuffer.AppendF("[[{} {} {} {}][{} {} {} {}][{} {} {} {}]]", this[0, 0], this[0, 1], this[0, 2], this[0,3], this[1, 0], this[1, 1], this[1, 2], this[1,3], this[2, 0], this[2, 1], this[2, 2], this[2,3]);
}