using Osteon;
using System;
namespace OsteonTest;

class Program
{
	public static void Main()
	{
		Vector2 a = .(1,1);
		let rot = Matrix3.Identity;
		a = (.)(rot * a);

		Console.WriteLine(rot);
		Console.WriteLine(a);
		Console.Read();
	}
}