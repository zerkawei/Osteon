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

		Console.WriteLine(a);
		Console.WriteLine(a.LengthSquared);
		Console.WriteLine(c);
		Console.WriteLine(d);
		Console.Read();
	} 
}