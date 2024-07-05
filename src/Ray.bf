namespace Osteon;

public struct Ray
{
	public Vector3 Origin;
	public Vector3 Direction;

	public this(Vector3 origin, Vector3 direction)
	{
		Origin    = origin;
		Direction = direction;
	}
}