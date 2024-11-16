using System;
using System.Numerics;
namespace Osteon;

public struct Matrix3
{
	public const Self Identity = .(1,0,0,
								   0,1,0,
								   0,0,1);

	private float[3][3] mVals;

	public this(float m00, float m01, float m02, float m10, float m11, float m12, float m20, float m21, float m22)
	{
#if OSTEON_COLUMN_MAJOR
		mVals = .(.(m00, m10, m20), .(m01, m11, m21), .(m02, m12, m22));
#else
		mVals = .(.(m00, m01, m02), .(m10, m11, m12), .(m20, m21, m22));
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
	public Self Transpose => .(this[0,0], this[1,0], this[2,0], this[0,1], this[1,1], this[2,1], this[0,2], this[1,2], this[2,2]);

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
	public static Vector2 operator*(Self a, Vector2 b) => .(b.X * a[0,0] + b.Y * a[0,1] + a[0,2], b.X * a[1,0] + b.Y * a[1,1] + a[1,2]);

	[DisableChecks, Optimize]
	public static Vector3 operator*(Self a, Vector3 b)
	{
#if OSTEON_COLUMN_MAJOR
		float4 tmp = float4(b.X,b.X,b.X,b.X) * *(float4*)&a.mVals[0]
			       + float4(b.Y,b.Y,b.Y,b.Y) * *(float4*)&a.mVals[1]
			       + float4(b.Z,b.Z,b.Z,b.Z) * *(float4*)&a.mVals[2];

		return *(Vector3*)&tmp;
#else
		Vector3 res = ?;

		float4 tmp = *(float4*)&b * *(float4*)&a.mVals[0];
		res.X = tmp.x + tmp.y + tmp.z;

		tmp = *(float4*)&b * *(float4*)&a.mVals[1];
		res.Y = tmp.x + tmp.y + tmp.z;

		tmp = *(float4*)&b * *(float4*)&a.mVals[2];
		res.Z = tmp.x + tmp.y + tmp.z;
		return res;
#endif
	}

	[DisableChecks, Optimize]
	public static Self operator*(Self a, Self b)
	{
		Self res = ?;
#if OSTEON_COLUMN_MAJOR
		for(let i < 3)
		{
			float4 col = .(b[0,i],b[0,i],b[0,i],b[0,i]) * *(float4*)&a.mVals[0]
					   + .(b[1,i],b[1,i],b[1,i],b[1,i]) * *(float4*)&a.mVals[1]
					   + .(b[2,i],b[2,i],b[2,i],b[2,i]) * *(float4*)&a.mVals[2];
			res.mVals[i] = .(col.x, col.y, col.z);
		}
		return res;
#else
		for(let i < 3)
		{
			float4 row = .(a[i,0],a[i,0],a[i,0],a[i,0]) * *(float4*)&b.mVals[0]
					   + .(a[i,1],a[i,1],a[i,1],a[i,1]) * *(float4*)&b.mVals[1]
					   + .(a[i,2],a[i,2],a[i,2],a[i,2]) * *(float4*)&b.mVals[2];
			res.mVals[i] = .(row.x, row.y, row.z);
		}
		return res;
#endif
	}

		public override void ToString(String strBuffer) => strBuffer.AppendF("[[{} {} {}][{} {} {}][{} {} {}]]", this[0, 0], this[0, 1], this[0, 2], this[1, 0], this[1, 1], this[1, 2], this[2, 0], this[2, 1], this[2, 2]);
}