using System;
using Osteon.Transform;
namespace Osteon.Shapes;

public struct AABB
{
	public Vector3 Minimum;
	public Vector3 Maximum;

	public this(Vector3 min, Vector3 max)
	{
		Minimum = min;
		Maximum = max;
	}

	public static Self CenterExtent(Vector3 center, Vector3 extent)
	{
		let e = extent / 2;
		return .(center - e, center + e);
	}

	public Vector3 Center => (Minimum + Maximum) / 2;
	public Vector3 Extent => Maximum - Minimum;
	public float Volume
	{
		get
		{
			let e = Extent;
			return e.X * e.Y * e.Z;
		}
	}

	public bool Contains(Vector3 pos) => pos >= Minimum && pos <= Maximum;
	public bool Contains(Self rect) => rect.Minimum >= Minimum && rect.Maximum <= Maximum;

	public bool Intersects (Self with) => (with.Minimum >= Minimum) ? with.Minimum <= Maximum : Contains(with.Maximum);
	public Result<Self> Intersection(Self with) => Intersects(with) ? Self(Vector3.Max(Minimum, with.Minimum), Vector3.Min(Maximum, with.Maximum)) : .Err;

	public Self Merge(Self with)   => .(Vector3.Min(Minimum, with.Minimum), Vector3.Max(Maximum, with.Maximum));
	public Self Expand(Vector3 to) => .(Vector3.Min(Minimum, to),           Vector3.Max(Maximum, to));

	[Commutable]
	public static Self operator+(Self lhs, Vector3 rhs) => .(lhs.Minimum + rhs, lhs.Maximum + rhs);
	[Commutable]
	public static Self operator*(Self lhs, float rhs)   => .(lhs.Minimum * rhs, lhs.Maximum * rhs);
	public static Self operator*(Matrix4 lhs, Self rhs)
	{
		let a = lhs * rhs.Minimum;
		let b = lhs * rhs.Maximum;

		return (a < b) ? .(a, b) : .(b, a);
	}
	public static Self operator*(Transform3D lhs, Self rhs)
	{
		let a = lhs * rhs.Minimum;
		let b = lhs * rhs.Maximum;

		return (a < b) ? .(a, b) : .(b, a);
	}
}