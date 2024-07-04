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

	public AABB Merge(AABB with)   => .(Vector3.Min(Minimum, with.Minimum), Vector3.Max(Maximum, with.Maximum));
	public AABB Expand(Vector3 to) => .(Vector3.Min(Minimum, to),           Vector3.Max(Maximum, to));

	[Commutable]
	public static Self operator+(Self lhs, Vector3 rhs) => .(lhs.Minimum + rhs, lhs.Maximum + rhs);
	[Commutable]
	public static Self operator*(Self lhs, float rhs)   => .(lhs.Minimum * rhs, lhs.Maximum * rhs);
}