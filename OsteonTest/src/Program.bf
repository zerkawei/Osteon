using Osteon;
using System;
namespace OsteonTest;

public class Program
{
	public static void Main()
	{
		Vector3 a = .(1,2,3);
		Vector3 b = .(3);

		Vector3 c = .(1);
		float d = 0;

		c = a + b;

		Console.WriteLine(Matrix3.Identity.Determinant);
		Console.WriteLine(Matrix3.Identity * a);

		Console.WriteLine(Matrix4.Identity * Matrix4.Identity);
		Console.WriteLine(Matrix3.Identity * Matrix3.Identity);

		Console.WriteLine(a);
		Console.WriteLine(a.LengthSquared);
		Console.WriteLine(c);
		Console.WriteLine(d);
		Console.Read();
	} 
}