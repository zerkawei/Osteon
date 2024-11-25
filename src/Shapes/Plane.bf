using System;
namespace Osteon.Shapes;

public struct Plane
{
	public static Self YZ = .(.UnitX);
	public static Self XZ = .(.UnitY);
	public static Self XY = .(.UnitZ);

	public Vector3 Normal;
	public float   D;

	public this(Vector3 normal, float d = 0)
	{
		Normal = normal;
		D      = d;
	}

	public this(float a, float b, float c, float d)
	{
		Normal = .(a,b,c);
		D      = d;
	}

	public Vector3 Center => D * Normal;
	public Self Normalized
	{
		get
		{
			var len = Normal.LengthSquared;
			if(len > 0)
			{
				len = Math.Sqrt(len);
				return .(Normal/len, D*len);
			}
			return .(0,0,0,0);
		}
	}

	public Vector3 Project(Vector3 p)  => p - DistanceTo(p) * Normal;
	public float DistanceTo(Vector3 p) => (Normal.Dot(p) + D);

	public bool SideOf    (Vector3 p)            => DistanceTo(p) > 0;
	public bool OnSameSide(Vector3 a, Vector3 b) => SideOf(a) == SideOf(b);
}