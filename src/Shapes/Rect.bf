using System;
using Osteon.Transform;
namespace Osteon.Shapes;

public struct Rect
{
	public Vector2 Minimum;
	public Vector2 Maximum;

	public this(Vector2 min, Vector2 max)
	{
		Minimum = min;
		Maximum = max;
	}

	public static Self CenterExtent(Vector2 center, Vector2 extent)
	{
		let e = extent / 2;
		return .(center - e, center + e);
	}

	public Vector2 Center => (Minimum + Maximum) / 2;
	public Vector2 Extent => Maximum - Minimum;
	public float Area
	{
		get
		{
			let e = Extent;
			return e.X * e.Y;
		}
	}

	public bool Contains(Vector2 pos) => pos >= Minimum && pos <= Maximum;
	public bool Contains(Self rect) => rect.Minimum >= Minimum && rect.Maximum <= Maximum;

	public bool Intersects (Self with) => (with.Minimum >= Minimum) ? with.Minimum <= Maximum : Contains(with.Maximum);
	public Result<Self> Intersection(Self with) => Intersects(with) ? Self(Vector2.Max(Minimum, with.Minimum), Vector2.Min(Maximum, with.Maximum)) : .Err;

	public Self Merge(Self with)   => .(Vector2.Min(Minimum, with.Minimum), Vector2.Max(Maximum, with.Maximum));
	public Self Expand(Vector2 to) => .(Vector2.Min(Minimum, to),           Vector2.Max(Maximum, to));

	[Commutable]
	public static Self operator+(Self lhs, Vector2 rhs) => .(lhs.Minimum + rhs, lhs.Maximum + rhs);
	[Commutable]
	public static Self operator*(Self lhs, float rhs)   => .(lhs.Minimum * rhs, lhs.Maximum * rhs);
	public static Self operator*(Matrix3 lhs, Self rhs)
	{
		let a = lhs * rhs.Minimum;
		let b = lhs * rhs.Maximum;

		return (a < b) ? .(a, b) : .(b, a);
	}
	public static Self operator*(Transform2D lhs, Self rhs)
	{
		let a = lhs * rhs.Minimum;
		let b = lhs * rhs.Maximum;

		return (a < b) ? .(a, b) : .(b, a);
	}
}