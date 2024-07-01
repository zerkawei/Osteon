using Osteon;
using System;
namespace OsteonTest;

class Program
{
	public static void Main()
	{
		Vector2 a = .(1,2);
		Vector2 b = .(4,5);

		let c = a.Dot(b);

		Console.WriteLine(c);
		Console.Read();
	}
}