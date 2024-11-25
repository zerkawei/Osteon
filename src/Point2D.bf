using System;
namespace Osteon;

[UnderlyingArray(typeof(int32), 2, true)]
public struct Point2D
{
	public const Self UnitX = .(1,0);
	public const Self UnitY = .(0,1);

	public int32 X;
	public int32 Y;

	public this(int32 val) : this(val, val) {}
	public this(int32 x, int32 y)
	{
		 X = x;
		 Y = y;
	}

	public extern float this[int idx] { [Intrinsic("index")] get; [Intrinsic("index")] set; }

	public float LengthSquared => Dot(this, this);
	public float Length => Math.Sqrt(Dot(this, this));

	public float DistanceSquared(Self other) => (this - other).LengthSquared;
	public float Distance(Self other) => (this - other).Length;

	public float Dot(Self other) => Dot(this, other);
	public static float Dot(Self lhs, Self rhs)
	{
		let c = lhs * rhs;
		return c.X + c.Y;
	}

	public float Angle => Math.Atan2(this.Y, this.X);

	[Intrinsic("add")]
	public static extern Self operator+(Self lhs, Self rhs);
	[Intrinsic("add"), Commutable]
	public static extern Self operator+(Self lhs, int32 rhs);

	[Intrinsic("sub")]
	public static extern Self operator-(Self lhs, Self rhs);
	[Intrinsic("sub"), Commutable]
	public static extern Self operator-(Self lhs, int32 rhs);

	[Intrinsic("mul")]
	public static extern Self operator*(Self lhs, Self rhs);
	[Intrinsic("mul"), Commutable]
	public static extern Self operator*(Self lhs, int32 rhs);

	[Intrinsic("div")]
	public static extern Self operator/(Self lhs, Self rhs);
	[Intrinsic("div")]
	public static extern Self operator/(Self lhs, int32 rhs);
	[Intrinsic("div")]
	public static extern Self operator/(int32 lhs, Self rhs);

	public static explicit operator Vector2(Self vec) => .(vec.X, vec.Y);
	public static explicit operator Self(Vector2 vec) => .((.)vec.X, (.)vec.Y);

	public override void ToString(String strBuffer) => strBuffer.AppendF("[{} {}]", X, Y);
}