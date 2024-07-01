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
		this[0,0] = m11; this[0,1] = m12; this[0,2] = m13;
		this[1,0] = m21; this[1,1] = m22; this[1,2] = m23;
		this[2,0] = m31; this[2,1] = m32; this[2,2] = m33;
	}

	public float Determinant =>
		this[0,0] * this[1,1] * this[2,2]
	  + this[0,1] * this[1,2] * this[2,0]
	  + this[0,2] * this[1,0] * this[1,2]
	  - this[0,2] * this[1,1] * this[2,0]
	  - this[0,1] * this[1,0] * this[2,2]
	  - this[0,0] * this[1,2] * this[2,1];

	public static Self operator*(Self a, Self b)
	{
		mixin C(int i, int j) { (a[i, 0] * b[0,j]) + (a[i, 1] * b[1,j]) + (a[i, 2] * b[2,j]) }
		return .(
			C!(0,0), C!(0,1), C!(0,2),
			C!(1,0), C!(1,1), C!(1,2),
			C!(2,0), C!(2,1), C!(2,2)
		);
	}
	public static Vector3 operator*(Self a, Vector3 b)
		=> .(
			a[0,0] * b.X + a[0,1] * b.Y + a[0,2] * b.Z,
			a[1,0] * b.X + a[1,1] * b.Y + a[1,2] * b.Z,
			a[2,0] * b.X + a[2,1] * b.Y + a[2,2] * b.Z
		);

	public static bool operator==(Self a, Self b)
		=> a[0,0] == b[0,0] && a[1,1] == b[1,1] && a[2,2] == b[2,2]
		&& a[0,1] == b[0,1] && a[1,2] == b[1,2] && a[2,0] == b[2,0]
		&& a[0,2] == b[0,2] && a[1,0] == b[1,0] && a[2,1] == b[2,1];
	public static bool operator!=(Self a, Self b)
		=> a[0,0] != b[0,0] || a[1,1] != b[1,1] || a[2,2] != b[2,2]
		|| a[0,1] != b[0,1] || a[1,2] != b[1,2] || a[2,0] != b[2,0]
		|| a[0,2] != b[0,2] || a[1,0] != b[1,0] || a[2,1] != b[2,1];
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
		this[0,0] = m11; this[0,1] = m12; this[0,2] = m13; this[0,3] = m14;
		this[1,0] = m21; this[1,1] = m22; this[1,2] = m23; this[1,3] = m24;
		this[2,0] = m31; this[2,1] = m32; this[2,2] = m33; this[2,3] = m34;
		this[3,0] = m41; this[3,1] = m42; this[3,2] = m43; this[3,3] = m44;
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
		mixin C(int i, int j) { (a[i, 0] * b[0,j]) + (a[i, 1] * b[1,j]) + (a[i, 2] * b[2,j]) + (a[i, 3] * b[3, j]) }
		return .(
			C!(0,0), C!(0,1), C!(0,2), C!(0,3),
			C!(1,0), C!(1,1), C!(1,2), C!(1,3),
			C!(2,0), C!(2,1), C!(2,2), C!(2,3),
			C!(3,0), C!(3,1), C!(3,2), C!(3,3)
		);
	}
	public static Vector4 operator*(Self a, Vector4 b)
		=> .(
			a[0,0] * b.X + a[0,1] * b.Y + a[0,2] * b.Z + a[0,3] * b.W,
			a[1,0] * b.X + a[1,1] * b.Y + a[1,2] * b.Z + a[1,3] * b.W,
			a[2,0] * b.X + a[2,1] * b.Y + a[2,2] * b.Z + a[2,3] * b.W,
			a[3,0] * b.X + a[3,1] * b.Y + a[3,2] * b.Z + a[3,3] * b.W
		);

	public static bool operator==(Self a, Self b)
		=> a[0,0] == b[0,0] && a[1,1] == b[1,1] && a[2,2] == b[2,2] && a[3,3] == b[3,3]
		&& a[0,1] == b[0,1] && a[1,2] == b[1,2] && a[2,3] == b[2,3] && a[3,0] == b[3,0]
		&& a[0,2] == b[0,2] && a[1,3] == b[1,3] && a[2,0] == b[2,0] && a[3,1] == b[3,1]
		&& a[0,3] == b[0,3] && a[1,0] == b[1,0] && a[2,1] == b[2,1] && a[3,2] == b[3,2];
	public static bool operator!=(Self a, Self b)
		=> a[0,0] != b[0,0] || a[1,1] != b[1,1] || a[2,2] != b[2,2] || a[3,3] != b[3,3]
		|| a[0,1] != b[0,1] || a[1,2] != b[1,2] || a[2,3] != b[2,3] || a[3,0] != b[3,0]
		|| a[0,2] != b[0,2] || a[1,3] != b[1,3] || a[2,0] != b[2,0] || a[3,1] != b[3,1]
		|| a[0,3] != b[0,3] || a[1,0] != b[1,0] || a[2,1] != b[2,1] || a[3,2] != b[3,2];
}