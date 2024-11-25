using Osteon.Transform;
namespace Osteon.Shapes;

public struct Ray3D
{
	public Vector3 Origin;
	public Vector3 Direction;

	public this(Vector3 origin, Vector3 direction)
	{
		Origin    = origin;
		Direction = direction;
	}

	public static Self operator*(Matrix4 lhs, Self rhs) => .(lhs * rhs.Origin, lhs * rhs.Direction);
	public static Self operator*(Transform3D lhs, Self rhs) => .(lhs * rhs.Origin, lhs * rhs.Direction);
}