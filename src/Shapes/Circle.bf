namespace Osteon.Shapes;

public struct Circle
{
	public Vector2 Center;
	public float   Radius;

	public this(Vector2 center, float radius)
	{
		Center = center;
		Radius = radius;
	}

	public bool Contains(Vector2 pos) => Center.DistanceSquared(pos) <= Radius*Radius;
	public bool Contains(Self circle)
	{
		let rr = Radius - circle.Radius;
		return Center.DistanceSquared(circle.Center) <= rr*rr;
	}

	public bool Intersects(Self with)
	{
		let rr = Radius + with.Radius;
		return Center.DistanceSquared(with.Center) <= rr*rr;
	}
}