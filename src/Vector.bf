using System;
using System.Numerics;
namespace Osteon;

[AttributeUsage(.Method, .None)]
public struct ElementWiseAttribute : Attribute, IOnMethodInit
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
    	for(let f in methodInfo.DeclaringType.GetFields(.Public | .Instance))
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
					s.Append(".");
					s.Append(f.Name);
				}
			}
		}
			
		}
		s.Append(";");
		Compiler.EmitMethodEntry(methodInfo, s);
	}
}

[UnderlyingArray(typeof(float), 2, true)]
public struct Vec2f
{
	public static Self Zero  = .(0);
	public static Self One   = .(1);
	public static Self UnitX = .(1,0);
	public static Self UnitY = .(0,1);

	public float X;
	public float Y;

	[Inline]
	public float Length => Math.Sqrt(Dot(this));
	[Inline]
	public float LengthSquared => Dot(this);
	[Inline]
	public float Angle => Math.Atan2(Y, X);
	public Self Normalized
	{
		get
		{
			let len = LengthSquared;
			return (len) == 0 ? Zero : this / Math.Sqrt(len);
		}
	}

	public this(float val) : this(val, val) {}
	public this(float x, float y)
	{
		X = x;
		Y = y;
	}
	public static Self FromAngle(float angle) => .(Math.Cos(angle), Math.Sin(angle));

	[Inline]
	public float Dot(Self rhs) => Dot(this, rhs);
	[Inline]
	public float Cross(Self rhs) => Cross(this, rhs);
	public float Distance(Self rhs) => (this - rhs).Length;
	public float SquaredDistance(Self rhs) => (this - rhs).LengthSquared;

	public Self Project(Self rhs) => rhs * (Dot(rhs) / rhs.LengthSquared);

	[ElementWise("*", "+")]
	public static float Dot (Self lhs, Self rhs) {}
	public static float Cross(Self lhs, Self rhs) => lhs.X * rhs.Y - lhs.Y * rhs.X;

	[ElementWise("Math.Abs")]      public static Self Abs  (Self val) {}
	[ElementWise("Math.Floor")]    public static Self Floor(Self val) {}
	[ElementWise("Math.Ceiling")]  public static Self Ceil (Self val) {}
	[ElementWise("Math.Round")]    public static Self Round(Self val) {}
	[ElementWise("Math.Sign")]     public static Self Sign (Self val) {}
	[ElementWise("Math.Clamp")]    public static Self Clamp(Self val, Self min, Self max) {}

	[ElementWise("+")]             public static Self operator+(Self lhs, Self rhs)  {}
	[ElementWise("+"), Commutable] public static Self operator+(Self lhs, float rhs) {}
	[ElementWise("-")]             public static Self operator-(Self lhs)            {}
	[ElementWise("-")]             public static Self operator-(Self lhs, Self rhs)  {}
	[ElementWise("-"), Commutable] public static Self operator-(Self lhs, float rhs) {}
	[ElementWise("*")]             public static Self operator*(Self lhs, Self rhs)  {}
	[ElementWise("*"), Commutable] public static Self operator*(Self lhs, float rhs) {}
	[ElementWise("/")]             public static Self operator/(Self lhs, Self rhs)  {}
	[ElementWise("/")]             public static Self operator/(Self lhs, float rhs) {}
	[ElementWise("/")]             public static Self operator/(float lhs, Self rhs) {}
	[ElementWise("==", "&&")]      public static bool operator==(Self lhs, Self rhs) {}
	[ElementWise("!=", "||")]      public static bool operator!=(Self lhs, Self rhs) {}
}

[UnderlyingArray(typeof(float), 3, true)]
public struct Vec3f
{
	public static Self Zero  = .(0);
	public static Self One   = .(1);
	public static Self UnitX = .(1,0,0);
	public static Self UnitY = .(0,1,0);
	public static Self UnitZ = .(0,0,1);

	public float X;
	public float Y;
	public float Z;

	[Inline]
	public float Length => Math.Sqrt(Dot(this));
	[Inline]
	public float LengthSquared => Dot(this);
	public Self Normalized
	{
		get
		{
			let len = LengthSquared;
			return (len) == 0 ? Zero : this / Math.Sqrt(len);
		}
	}

	public this(float val) : this(val, val, val) {}
	public this(float x, float y, float z)
	{
		X = x;
		Y = y;
		Z = z;
	}

	[Inline]
	public float Dot(Self rhs) => Dot(this, rhs);
	[Inline]
	public Self Cross(Self rhs) => Cross(this, rhs);
	public float Distance(Self rhs) => (this - rhs).Length;
	public float SquaredDistance(Self rhs) => (this - rhs).LengthSquared;

	public Self Project(Self rhs) => rhs * (Dot(rhs) / rhs.LengthSquared);

	[ElementWise("*", "+")]
	public static float Dot (Self lhs, Self rhs) {}
	public static Self Cross(Self lhs, Self rhs) => .(
		(lhs.Y * rhs.Z) - (lhs.Z * rhs.Y),
		(lhs.Z * rhs.X) - (lhs.X * rhs.Z),
		(lhs.X * rhs.Y) - (lhs.Y * rhs.X)
	);

	[ElementWise("Math.Abs")]      public static Self Abs  (Self val) {}
	[ElementWise("Math.Floor")]    public static Self Floor(Self val) {}
	[ElementWise("Math.Ceiling")]  public static Self Ceil (Self val) {}
	[ElementWise("Math.Round")]    public static Self Round(Self val) {}
	[ElementWise("Math.Sign")]     public static Self Sign (Self val) {}
	[ElementWise("Math.Clamp")]    public static Self Clamp(Self val, Self min, Self max) {}

	[ElementWise("+")]             public static Self operator+(Self lhs, Self rhs)  {}
	[ElementWise("+"), Commutable] public static Self operator+(Self lhs, float rhs) {}
	[ElementWise("-")]             public static Self operator-(Self lhs)            {}
	[ElementWise("-")]             public static Self operator-(Self lhs, Self rhs)  {}
	[ElementWise("-"), Commutable] public static Self operator-(Self lhs, float rhs) {}
	[ElementWise("*")]             public static Self operator*(Self lhs, Self rhs)  {}
	[ElementWise("*"), Commutable] public static Self operator*(Self lhs, float rhs) {}
	[ElementWise("/")]             public static Self operator/(Self lhs, Self rhs)  {}
	[ElementWise("/")]             public static Self operator/(Self lhs, float rhs) {}
	[ElementWise("/")]             public static Self operator/(float lhs, Self rhs) {}
	[ElementWise("==", "&&")]      public static bool operator==(Self lhs, Self rhs) {}
	[ElementWise("!=", "||")]      public static bool operator!=(Self lhs, Self rhs) {}
}

[UnderlyingArray(typeof(float), 4, true)]
public struct Vec4f
{
	public static Self Zero  = .(0);
	public static Self One   = .(1);
	public static Self UnitX = .(1,0,0,0);
	public static Self UnitY = .(0,1,0,0);
	public static Self UnitZ = .(0,0,1,0);
	public static Self UnitW = .(0,0,0,1);

	public float X;
	public float Y;
	public float Z;
	public float W;

	[Inline]
	public float Length => Math.Sqrt(Dot(this));
	[Inline]
	public float LengthSquared => Dot(this);
	public Self Normalized
	{
		get
		{
			let len = LengthSquared;
			return (len) == 0 ? Zero : this / Math.Sqrt(len);
		}
	}

	public this(float val) : this(val, val, val, val) {}
	public this(float x, float y, float z, float w)
	{
		X = x;
		Y = y;
		Z = z;
		W = w;
	}

	[Inline]
	public float Dot(Self rhs) => Dot(this, rhs);
	public float Distance(Self rhs) => (this - rhs).Length;
	public float SquaredDistance(Self rhs) => (this - rhs).LengthSquared;

	public Self Project(Self rhs) => rhs * (Dot(rhs) / rhs.LengthSquared);

	[ElementWise("*", "+")]
	public static float Dot (Self lhs, Self rhs) {}

	[ElementWise("Math.Abs")]      public static Self Abs  (Self val) {}
	[ElementWise("Math.Floor")]    public static Self Floor(Self val) {}
	[ElementWise("Math.Ceiling")]  public static Self Ceil (Self val) {}
	[ElementWise("Math.Round")]    public static Self Round(Self val) {}
	[ElementWise("Math.Sign")]     public static Self Sign (Self val) {}
	[ElementWise("Math.Clamp")]    public static Self Clamp(Self val, Self min, Self max) {}

	[ElementWise("+")]             public static Self operator+(Self lhs, Self rhs)  {}
	[ElementWise("+"), Commutable] public static Self operator+(Self lhs, float rhs) {}
	[ElementWise("-")]             public static Self operator-(Self lhs)            {}
	[ElementWise("-")]             public static Self operator-(Self lhs, Self rhs)  {}
	[ElementWise("-"), Commutable] public static Self operator-(Self lhs, float rhs) {}
	[ElementWise("*")]             public static Self operator*(Self lhs, Self rhs)  {}
	[ElementWise("*"), Commutable] public static Self operator*(Self lhs, float rhs) {}
	[ElementWise("/")]             public static Self operator/(Self lhs, Self rhs)  {}
	[ElementWise("/")]             public static Self operator/(Self lhs, float rhs) {}
	[ElementWise("/")]             public static Self operator/(float lhs, Self rhs) {}
	[ElementWise("==", "&&")]      public static bool operator==(Self lhs, Self rhs) {}
	[ElementWise("!=", "||")]      public static bool operator!=(Self lhs, Self rhs) {}
}