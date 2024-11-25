namespace Osteon.Shapes;

public struct Sphere
{
	public Vector3 Center;
	public float   Radius;

	public this(Vector3 center, float radius)
	{
		Center = center;
		Radius = radius;
	}

	public bool Contains(Vector3 pos) => Center.DistanceSquared(pos) <= Radius*Radius;
	public bool Contains(Self sphere)
	{
		let rr = Radius - sphere.Radius;
		return Center.DistanceSquared(sphere.Center) <= rr*rr;
	}

	public bool Intersects(Self with)
	{
		let rr = Radius + with.Radius;
		return Center.DistanceSquared(with.Center) <= rr*rr;
	}
}