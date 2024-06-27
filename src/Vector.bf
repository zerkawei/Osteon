using System;
using System.Numerics;
namespace Osteon;

[AttributeUsage(.Method, .None)]
public struct ReduceAttribute : Attribute, IOnMethodInit
{
	public StringView intrinsic;
	public StringView op;
	public this(StringView intrinsic, StringView op)
	{
		this.intrinsic = intrinsic;
		this.op = op;
	}

	[Comptime]
	public void OnMethodInit(System.Reflection.MethodInfo methodInfo, Self* prev)
	{
		let t = methodInfo.DeclaringType.GetMethod(intrinsic, .Static | .NonPublic).Value.ReturnType;

		let s = scope String();

		s.Append(scope $"let val = {intrinsic}(");

		for(let i < methodInfo.ParamCount)
		{
			if(i > 0) s.Append(", ");
			s.Append(methodInfo.GetParamName(i));
		}

		s.Append(");\nreturn ");

		var first = true;
		for(let f in t.GetFields(.Public | .Instance))
		{
			if(!first)
			{
				s.Append(op);
			}
			else
			{
				first = false;
			}
			s.Append(scope $"val.{f.Name}");
		}

		s.Append(";");
		Compiler.EmitMethodEntry(methodInfo, s);
	}
}

[UnderlyingArray(typeof(float), 2, true)]
public struct Vec2f
{
	public static Self Zero     = .(0);
	public static Self One      = .(1);
	public static Self Unit     = .(1,0);

	public float X;
	public float Y;

	public this(float val)
	{
		X = val;
		Y = val;
	}

	public this(float x, float y)
	{
		X = x;
		Y = y;
	}

	public static Self FromAngle(float angle) => .(Math.Cos(angle), Math.Sin(angle));

	[Intrinsic("mul")]
	private static extern Self mul(Self lhs, Self rhs);
	[Intrinsic("eq")]
	private static extern bool2 eq(Self lhs, Self rhs);
	[Intrinsic("neq")]
	private static extern bool2 neq(Self lhs, Self rhs);
	[Intrinsic("lt")]
	private static extern bool2 lt(Self lhs, Self rhs);
	[Intrinsic("lte")]
	private static extern bool2 lte(Self lhs, Self rhs);
	[Intrinsic("gt")]
	private static extern bool2 gt(Self lhs, Self rhs);
	[Intrinsic("gte")]
	private static extern bool2 gte(Self lhs, Self rhs);

	[Intrinsic("add")]
	public static extern Self operator+(Self lhs, Self rhs);
	[Intrinsic("add"), Commutable]
	public static extern Self operator+(Self lhs, float rhs);

	[Intrinsic("sub")]
	public static extern Self operator-(Self lhs, Self rhs);
	[Intrinsic("sub"), Commutable]
	public static extern Self operator-(Self lhs, float rhs);

	[Intrinsic("mul"), Commutable]
	public static extern Self operator*(Self lhs, float rhs);
	[Intrinsic("div"), Commutable]
	public static extern Self operator/(Self lhs, float rhs);

	[Intrinsic("abs")]
	public static extern Self Abs(Self val);
	[Intrinsic("floor")]
	public static extern Self Floor(Self val);
	[Intrinsic("round")]
	public static extern Self Round(Self val);

	[Reduce("eq", "&&")]
	public static bool operator==(Self lhs, Self rhs){}
	[Reduce("neq", "&&")]
	public static bool operator!=(Self lhs, Self rhs){}
	[Reduce("lt", "&&")]
	public static bool operator<(Self lhs, Self rhs){}
	[Reduce("lte", "&&")]
	public static bool operator<=(Self lhs, Self rhs){}
	[Reduce("gt", "&&")]
	public static bool operator>(Self lhs, Self rhs){}
	[Reduce("gte", "&&")]
	public static bool operator>=(Self lhs, Self rhs){}
	[Reduce("mul", "+")]
	public static float Dot(Self lhs, Self rhs){}
	public static float Cross(Self lhs, Self rhs) => lhs.X * rhs.Y - lhs.Y * rhs.X;


	[Inline]
	public float Dot(Self rhs)   => Dot(this, rhs);
	[Inline]
	public float Cross(Self rhs) => Cross(this, rhs);
	[Inline]
	public float Length          => Math.Sqrt(Dot(this));
	[Inline]
	public float LengthSquared   => Dot(this);
	[Inline]
	public float Angle           => Math.Atan2(Y, X);

	public Self Normalized
	{
		get
		{
			let len = LengthSquared;
			return (len) == 0 ? Zero : this / Math.Sqrt(len);
		}
	}


}