using System;
namespace Osteon;

public struct AABB
{
	public Vector3 Minimum;
	public Vector3 Maximum;

	public Vector3 Center => (Minimum + Maximum) / 2;
	public Vector3 Extent => Maximum - Minimum;
	public float   Volume
	{
		get
		{
			let e = Extent;
			return e.X * e.Y * e.Z;
		}
	}

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

	public bool Contains(Vector3 pos) => pos >= Minimum && pos <= Maximum;
	public bool Contains(AABB bb) => bb.Minimum >= Minimum && bb.Maximum <= Maximum;

	public bool         Intersects  (AABB with)  => (with.Minimum >= Minimum) ? with.Minimum <= Maximum : Contains(with.Maximum);
	public Result<AABB> Intersection(AABB with)  => Intersects(with) ? AABB(Vector3.Max(Minimum, with.Minimum), Vector3.Min(Maximum, with.Maximum)) : .Err;
	public bool         Intersects  (Plane with) => !with.OnSameSide(Minimum, Maximum);
	public bool         Intersects  (Ray with)
	{
		// Algorithm source : https://tavianator.com/2011/ray_box.html
		let t1 = (Minimum - with.Origin)/with.Direction;
		let t2 = (Maximum - with.Origin)/with.Direction;

		let tmin = Vector3.Min(t1, t2);
		let tmax = Vector3.Max(t1, t2);

		let min = Math.Max(tmin.X, Math.Max(tmin.Y, tmin.Z));
		let max = Math.Min(tmax.X, Math.Min(tmax.Y, tmax.Z));

		return max >= 0 && max >= min;
	}

	public AABB Merge(AABB with)   => .(Vector3.Min(Minimum, with.Minimum), Vector3.Max(Maximum, with.Maximum));
	public AABB Expand(Vector3 to) => .(Vector3.Min(Minimum, to),           Vector3.Max(Maximum, to));

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
}