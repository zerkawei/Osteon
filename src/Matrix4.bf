using System;
using System.Numerics;
namespace Osteon;

public struct Matrix4
{
	public const Self Identity = .(1,0,0,0,
								   0,1,0,0,
								   0,0,1,0,
								   0,0,0,1);

	private float[4][4] mVals;

	public this(float m00, float m01, float m02, float m03, float m10, float m11, float m12, float m13, float m20, float m21, float m22, float m23, float m30, float m31, float m32, float m33)
	{
#if OSTEON_COLUMN_MAJOR
		mVals = .(.(m00, m10, m20, m30), .(m01, m11, m21, m31), .(m02, m12, m22, m32), .(m03, m13, m23, m33));
#else
		mVals = .(.(m00, m01, m02, m03), .(m10, m11, m12, m13), .(m20, m21, m22, m23), .(m30, m31, m32, m33));
#endif
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

	[DisableChecks, Optimize]
	public Self Transpose => .(this[0,0], this[1,0], this[2,0], this[3,0], this[0,1], this[1,1], this[2,1], this[3,1], this[0,2], this[1,2], this[2,2], this[3,2], this[0,3], this[1,3], this[2,3], this[3,3]);

	/* TODO
	public float Determinant
	{

		[DisableChecks, Optimize]
		get
		{
		}
	}
	*/

	[DisableChecks, Optimize]
	public static Vector4 operator*(Self a, Vector4 b)
	{
#if OSTEON_COLUMN_MAJOR
		float4 tmp = float4(b.X,b.X,b.X,b.X) * *(float4*)&a.mVals[0]
			       + float4(b.Y,b.Y,b.Y,b.Y) * *(float4*)&a.mVals[1]
			       + float4(b.Z,b.Z,b.Z,b.Z) * *(float4*)&a.mVals[2]
			       + float4(b.W,b.W,b.W,b.W) * *(float4*)&a.mVals[3];;

		return *(Vector4*)&tmp;
#else
		Vector4 res = ?;

		float4 tmp = *(float4*)&b * *(float4*)&a.mVals[0];
		res.X = tmp.x + tmp.y + tmp.z + tmp.w;

		tmp = *(float4*)&b * *(float4*)&a.mVals[1];
		res.Y = tmp.x + tmp.y + tmp.z + tmp.w;

		tmp = *(float4*)&b * *(float4*)&a.mVals[2];
		res.Z = tmp.x + tmp.y + tmp.z + tmp.w;

		tmp = *(float4*)&b * *(float4*)&a.mVals[3];
		res.W = tmp.x + tmp.y + tmp.z + tmp.w;
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
					   + .(b[2,i],b[2,i],b[2,i],b[2,i]) * [Inline]BitConverter.Convert<?,float4>(a.mVals[2])
					   + .(b[3,i],b[3,i],b[3,i],b[3,i]) * [Inline]BitConverter.Convert<?,float4>(a.mVals[3]);
			res.mVals[i] = *(float[4]*)&col;
		}
		return res;
#else
		for(let i < 4)
		{
			float4 row = .(a[i,0],a[i,0],a[i,0],a[i,0]) * [Inline]BitConverter.Convert<?,float4>(b.mVals[0])
					   + .(a[i,1],a[i,1],a[i,1],a[i,1]) * [Inline]BitConverter.Convert<?,float4>(b.mVals[1])
					   + .(a[i,2],a[i,2],a[i,2],a[i,2]) * [Inline]BitConverter.Convert<?,float4>(b.mVals[2])
					   + .(a[i,3],a[i,3],a[i,3],a[i,3]) * [Inline]BitConverter.Convert<?,float4>(b.mVals[3]);
			res.mVals[i] = *(float[4]*)&row;
		}
		return res;
#endif
	}

	public override void ToString(String strBuffer) => strBuffer.AppendF("[[{} {} {} {}][{} {} {} {}][{} {} {} {}][{} {} {} {}]]", this[0, 0], this[0, 1], this[0, 2], this[0, 3], this[1, 0], this[1, 1], this[1, 2], this[1, 3], this[2, 0], this[2, 1], this[2, 2], this[2, 3], this[3, 0], this[3, 1], this[3, 2], this[3, 3]);
}