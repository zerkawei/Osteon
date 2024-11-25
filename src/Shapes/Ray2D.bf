using Osteon.Transform;
namespace Osteon.Shapes;

public struct Ray2D
{
	public Vector2 Origin;
	public Vector2 Direction;

	public this(Vector2 origin, Vector2 direction)
	{
		Origin    = origin;
		Direction = direction;
	}

	public static Self operator*(Matrix3 lhs, Self rhs) => .(lhs * rhs.Origin, lhs * rhs.Direction);
	public static Self operator*(Transform2D lhs, Self rhs) => .(lhs * rhs.Origin, lhs * rhs.Direction);
}