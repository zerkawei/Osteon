using System;
using System.Numerics;
namespace Osteon.Transform;

public struct Transform2D
{
	public const Self Identity = .(1,0,0,
								   0,1,0);

#if OSTEON_COLUMN_MAJOR
	private float[3][2] mVals;
#else
	private float[2][3] mVals;
#endif

	public this(float m00, float m01, float m02, float m10, float m11, float m12)
	{
#if OSTEON_COLUMN_MAJOR
		mVals = .(.(m00, m10), .(m01, m11), .(m02, m12));
#else
		mVals = .(.(m00, m01, m02), .(m10, m11, m12));
#endif
	}

	public static Self Translate(Vector2 by) => .(1,0,by.X,
											      0,1,by.Y);

	public static Self Scale(Vector2 by) => .(by.X,0,0,
		                                      0,by.Y,0);

	public static Self Scale(float by) => .(by,0,0,
		                                    0,by,0);

	public static Self Rotate(float by) => .(Math.Cos(by),-Math.Sin(by),0,
		                                     Math.Sin(by), Math.Cos(by),0);

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

	public float Determinant => this[0,0] * this[1,1] - this[0,1] * this[1,0];

	[DisableChecks, Optimize]
	public static Vector2 operator*(Self a, Vector2 b) => .(b.X * a[0,0] + b.Y * a[0,1] + a[0,2], b.X * a[1,0] + b.Y * a[1,1] + a[1,2]);

	[DisableChecks, Optimize]
	public static Self operator*(Self a, Self b)
	{
		Self res = ?;
#if OSTEON_COLUMN_MAJOR
		float4 tmp = .(a[0,0],a[1,0],a[0,1],a[1,1])*.(b[0,0],b[0,0],b[1,2],b[1,2]) + .(a[0,1],a[1,1],a[0,2],a[1,2])*.(b[1,0],b[1,0],1,1);
		res.mVals[0] = .(tmp.x, tmp.y);
		res.mVals[2] = .(tmp.z, tmp.w);
		tmp = .(a[0,0],a[1,0],a[0,1],a[1,1])*.(b[0,1],b[0,1],b[1,1],b[1,1]);
		res.mVals[1] = .(tmp.x + tmp.z, tmp.y + tmp.w);
#else
		for(let i < 2)
		{
			float4 row = .(a[i,0],a[i,0],a[i,0],a[i,0]) * *(float4*)&b.mVals[0]
					   + .(a[i,1],a[i,1],a[i,1],a[i,1]) * *(float4*)&b.mVals[1];
			res.mVals[i] = .(row.x, row.y, row.z + a[i,2]);
		}
#endif
		return res;
	}

	public static explicit operator Matrix3(Self m) => .(m[0,0],m[0,1],m[0,2],m[1,0],m[1,1],m[1,2],0,0,1);
	public override void ToString(String strBuffer) => strBuffer.AppendF("[[{} {} {}][{} {} {}]]", this[0, 0], this[0, 1], this[0, 2], this[1, 0], this[1, 1], this[1, 2]);
}