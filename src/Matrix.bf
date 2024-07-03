using System;		  
namespace Osteon;

[AttributeUsage(.Method, .None)]
public struct MatrixOperatorAttribute<T> : Attribute, IOnMethodInit where T : const int
{
	public StringView method;
	public StringView reducer;

	public this(StringView method ,StringView reducer = "")
	{
		this.method = method;
		this.reducer = reducer;
	}

	[Comptime]
	public void OnMethodInit(System.Reflection.MethodInfo methodInfo, Self* prev)
	{
		let s = scope String();
		s.Append(scope $"return ");

End:	{
		StringView topSeparator;
		if(reducer == "")
		{
			s.Append(".(");
			topSeparator = ", ";

			defer :End s.Append(")");
		}
		else { topSeparator = reducer; }

		var first = true;
    	for(let i < T*T)
Loop:	{
			if(!first) s.Append(topSeparator); else first = false;

			StringView separator;
			if(method[0].IsLetter || method[0] == '_')
			{
				s.Append(method);
				s.Append("(");
				separator = ", ";

				defer :Loop s.Append(")");
			}
			else { separator = method; }

			for(let p < methodInfo.ParamCount)
			{
				if(p > 0 || (separator == method && methodInfo.ParamCount == 1)) s.Append(separator);
				let t = methodInfo.GetParamType(p);
				s.Append(methodInfo.GetParamName(p));
				if(!t.IsPrimitive)
				{
					s.Append(scope $"[{i%T},{(i%T + i/T)%T}]");
				}
			}
		}
			
		}
		s.Append(";");
		Compiler.EmitMethodEntry(methodInfo, s);
	}
}

[Union, Ordered]
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

	public float Determinant =>
		this[0,0] * this[1,1] * this[2,2]
		+ this[0,1] * this[1,2] * this[2,0]
		+ this[0,2] * this[1,0] * this[1,2]
		- this[0,2] * this[1,1] * this[2,0]
		- this[0,1] * this[1,0] * this[2,2]
		- this[0,0] * this[1,2] * this[2,1];
	public Matrix3 Transpose =>
		.(this[0,0], this[1,0], this[2,0],
		  this[0,1], this[1,1], this[2,1],
		  this[0,2], this[1,2], this[2,2]);

	public this(Vector3[3] columns) { mColumns = columns; }
	public this(float m11, float m12, float m13, float m21, float m22, float m23, float m31, float m32, float m33)
	{
		mValues = .(
			.(m11, m21, m31),
			.(m12, m22, m32),
			.(m13, m23, m33)
			);
	}
	public static Self Translation(Vector2 by) =>
		.(1, 0, by.X,
		  0, 1, by.Y,
		  0, 0, 1);
	public static Self Scale(Vector2 by) =>
		.(by.X, 0,    0,
		  0,    by.Y, 0,
		  0,    0,    1);
	public static Self Rotation(float by)
	{
		let s = Math.Sin(by);
		let c = Math.Cos(by);

		return .(c, -s, 0, s, c, 0, 0, 0, 1);
	}

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
	
	[MatrixOperator<3>("+")]             public static Self operator+ (Self a, Self b)  {}
	[MatrixOperator<3>("+"), Commutable] public static Self operator+ (Self a, float b) {}
	[MatrixOperator<3>("-")]             public static Self operator- (Self a, Self b)  {}
	[MatrixOperator<3>("-"), Commutable] public static Self operator- (Self a, float b) {}
	[MatrixOperator<3>("*"), Commutable] public static Self operator* (Self a, float b) {}
	[MatrixOperator<3>("==", "&&")]      public static bool operator==(Self a, Self b)  {}
	[MatrixOperator<3>("!=", "||")]      public static bool operator!=(Self a, Self b)  {}

	public override void ToString(String strBuffer)
	{
		mValues.ToString(strBuffer);
	} 
}

[Union, Ordered]
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
	public Matrix4 Transpose =>
		.(this[0,0], this[1,0], this[2,0], this[3,0],
		  this[0,1], this[1,1], this[2,1], this[3,1],
		  this[0,2], this[1,2], this[2,2], this[3,2],
		  this[0,3], this[1,3], this[2,3], this[3,3]);

	public this(Vector4[4] columns) { mColumns = columns; }
	public this(float m11, float m12, float m13, float m14, float m21, float m22, float m23, float m24, float m31, float m32, float m33, float m34, float m41, float m42, float m43, float m44)
	{
		mValues = .(
			.(m11, m21, m31, m41),
			.(m12, m22, m32, m42),
			.(m13, m23, m33, m43),
			.(m14, m24, m34, m44)
			);
	}
	public static Self Translation(Vector3 by) =>
		.(1, 0, 0, by.X,
		  0, 1, 0, by.Y,
		  0, 0, 1, by.Z,
		  0, 0, 0, 1);
	public static Self Scale(Vector3 by) =>
		.(by.X, 0,    0,    0,
		  0,    by.Y, 0,    0,
		  0,    0,    by.Z, 0,
		  0,    0,    0,    1);
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
				 zx - s.Y, yz + s.X, zz + c,   0,
			     0,        0,        0,        1);
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

	[MatrixOperator<4>("+")]             public static Self operator+ (Self a, Self b)  {}
	[MatrixOperator<4>("+"), Commutable] public static Self operator+ (Self a, float b) {}
	[MatrixOperator<4>("-")]             public static Self operator- (Self a, Self b)  {}
	[MatrixOperator<4>("-"), Commutable] public static Self operator- (Self a, float b) {}
	[MatrixOperator<4>("*"), Commutable] public static Self operator* (Self a, float b) {}
	[MatrixOperator<4>("==", "&&")]      public static bool operator==(Self a, Self b)  {}
	[MatrixOperator<4>("!=", "||")]      public static bool operator!=(Self a, Self b)  {}
}
