namespace Osteon.Shapes;

public struct Line
{
	public static Self YAxis = .(.UnitX);
	public static Self XAxis = .(.UnitY);

	public Vector2 Normal;
	public float   C;

	public this(Vector2 normal, float c = 0)
	{
		Normal = normal;
		C      = c;
	}

	public this(float a, float b, float c)
	{
		Normal = .(a,b);
		C      = c;
	}
}