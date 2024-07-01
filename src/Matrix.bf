using System;		  
namespace Osteon;

[Union, UnderlyingArray(typeof(float), 9, true)]
public struct Matrix3
{
	public static Self Identity = .(.(.UnitX, .UnitY, .UnitZ));

	private float[3][3] mValues;
	private Vector3 [3] mColumns;

	public float this[int row, int column]
	{
		[Inline] get     => mValues[column][row];
		[Inline] set mut => mValues[column][row] = value;
	}
	public Vector3 this[int column]
	{
		[Inline] get     => mColumns[column];
		[Inline] set mut => mColumns[column] = value;
	}

	public this(Vector3[3] columns) { mColumns = columns; }
	public this(float m11, float m12, float m13, float m21, float m22, float m23, float m31, float m32, float m33)
	{
		this = ?;
		this[1,1] = m11; this[1,2] = m12; this[1,3] = m13;
		this[2,1] = m21; this[2,2] = m22; this[2,3] = m23;
		this[3,1] = m31; this[3,2] = m32; this[3,3] = m33;
	}

	public float Determinant =>
		this[1,1] * this[2,2] * this[3,3]
 	  + this[1,2] * this[2,3] * this[3,1]
	  + this[1,3] * this[2,1] * this[2,3]
	  - this[1,3] * this[2,2] * this[3,1]
	  - this[1,2] * this[2,1] * this[3,3]
	  - this[1,1] * this[2,3] * this[3,2];

	public static Self operator*(Self a, Self b)
	{
		mixin C(int i, int j) { (a[i, 1] * b[1,j]) + (a[i, 2] * b[2,j]) + (a[i, 3] * b[3,j]) }
		return .(
			C!(1,1), C!(1,2), C!(1,3),
			C!(2,1), C!(2,2), C!(2,3),
			C!(3,1), C!(3,2), C!(3,3)
		);
	}
	public static Vector3 operator*(Self a, Vector3 b)
		=> .(
			a[1,1] * b.X + a[1,2] * b.Y + a[1,3] * b.Z,
			a[2,1] * b.X + a[2,2] * b.Y + a[2,3] * b.Z,
			a[3,1] * b.X + a[3,2] * b.Y + a[3,3] * b.Z
		);

	public static bool operator==(Self a, Self b)
		=> a[1,1] == b[1,1] && a[2,2] == b[2,2] && a[3,3] == b[3,3]
		&& a[1,2] == b[1,2] && a[2,3] == b[2,3] && a[3,1] == b[3,1]
		&& a[1,3] == b[1,3] && a[2,1] == b[2,1] && a[3,2] == b[3,2];
	public static bool operator!=(Self a, Self b)
		=> a[1,1] != b[1,1] || a[2,2] != b[2,2] || a[3,3] != b[3,3]
		|| a[1,2] != b[1,2] || a[2,3] != b[2,3] || a[3,1] != b[3,1]
		|| a[1,3] != b[1,3] || a[2,1] != b[2,1] || a[3,2] != b[3,2];
}

[Union, UnderlyingArray(typeof(float), 16, true)]
public struct Matrix4
{
	public static Self Identity = .(.(.UnitX, .UnitY, .UnitZ, .UnitW));

	private float[4][4] mValues;
	private Vector4 [4] mColumns;

	public float this[int row, int column]
	{
		[Inline] get     => mValues[column][row];
		[Inline] set mut => mValues[column][row] = value;
	}
	public Vector4 this[int column]
	{
		[Inline] get     => mColumns[column];
		[Inline] set mut => mColumns[column] = value;
	}

	public this(Vector4[4] columns) { mColumns = columns; }
	public this(float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44)
	{
		this = ?;
		this[1,1] = m11; this[1,2] = m12; this[1,3] = m13; this[1,4] = m14;
		this[2,1] = m21; this[2,2] = m22; this[2,3] = m23; this[2,4] = m24;
		this[3,1] = m31; this[3,2] = m32; this[3,3] = m33; this[3,4] = m34;
		this[4,1] = m41; this[4,2] = m42; this[4,3] = m43; this[4,4] = m44;
	}

	public float Determinant
	{
		get
		{
			let m0312 = this[0,3] * this[1,2];
			let m0213 = this[0,2] * this[1,3];
			let m0311 = this[0,3] * this[1,1];
			let m0113 = this[0,1] * this[1,3];
			let m0211 = this[0,2] * this[1,1];
			let m0112 = this[0,1] * this[1,2];
			let m0310 = this[0,3] * this[1,0];
			let m0013 = this[0,0] * this[1,3];
			let m0210 = this[0,2] * this[1,0];
			let m0012 = this[0,0] * this[1,2];
			let m0110 = this[0,1] * this[1,0];
			let m0011 = this[0,0] * this[1,1];

			return (m0312 - m0213) * this[2,1] * this[3,0] -
				   (m0311 + m0113) * this[2,2] * this[3,0] + 
				   (m0211 - m0112) * this[2,3] * this[3,0] -
				   (m0312 + m0213) * this[2,0] * this[3,1] +
				   (m0310 - m0013) * this[2,2] * this[3,1] -
				   (m0210 + m0012) * this[2,3] * this[3,1] + 
				   (m0311 - m0113) * this[2,0] * this[3,2] -
				   (m0310 + m0013) * this[2,1] * this[3,2] +
				   (m0110 - m0011) * this[2,3] * this[3,2] -
				   (m0211 + m0112) * this[2,0] * this[3,3] + 
				   (m0210 - m0012) * this[2,1] * this[3,3] -
				   (m0110 + m0011) * this[2,2] * this[3,3];
		}
	}

	public static Self operator*(Self a, Self b)
	{
		mixin C(int i, int j) { (a[i, 1] * b[1,j]) + (a[i, 2] * b[2,j]) + (a[i, 3] * b[3,j]) + (a[i, 4] * b[4, j]) }
		return .(
			C!(1,1), C!(1,2), C!(1,3), C!(1,4),
			C!(2,1), C!(2,2), C!(2,3), C!(2,4),
			C!(3,1), C!(3,2), C!(3,3), C!(3,4),
			C!(4,1), C!(4,2), C!(4,3), C!(4,4)
		);
	}
	public static Vector4 operator*(Self a, Vector4 b)
		=> .(
			a[1,1] * b.X + a[1,2] * b.Y + a[1,3] * b.Z + a[1,4] * b.W,
			a[2,1] * b.X + a[2,2] * b.Y + a[2,3] * b.Z + a[2,4] * b.W,
			a[3,1] * b.X + a[3,2] * b.Y + a[3,3] * b.Z + a[3,4] * b.W,
			a[4,1] * b.X + a[4,2] * b.Y + a[4,3] * b.Z + a[4,4] * b.W
		);

	public static bool operator==(Self a, Self b)
		=> a[1,1] == b[1,1] && a[2,2] == b[2,2] && a[3,3] == b[3,3] && a[4,4] == b[4,4]
		&& a[1,2] == b[1,2] && a[2,3] == b[2,3] && a[3,4] == b[3,4] && a[4,1] == b[4,1]
		&& a[1,3] == b[1,3] && a[2,4] == b[2,4] && a[3,1] == b[3,1] && a[4,2] == b[4,2]
		&& a[1,4] == b[1,4] && a[2,1] == b[2,1] && a[3,2] == b[3,2] && a[4,3] == b[4,3];
	public static bool operator!=(Self a, Self b)
		=> a[1,1] != b[1,1] || a[2,2] != b[2,2] || a[3,3] != b[3,3] || a[4,4] != b[4,4]
		|| a[1,2] != b[1,2] || a[2,3] != b[2,3] || a[3,4] != b[3,4] || a[4,1] != b[4,1]
		|| a[1,3] != b[1,3] || a[2,4] != b[2,4] || a[3,1] != b[3,1] || a[4,2] != b[4,2]
		|| a[1,4] != b[1,4] || a[2,1] != b[2,1] || a[3,2] != b[3,2] || a[4,3] != b[4,3];
}