using Osteon;
using System;
namespace OsteonTest;

class Program
{
	public static void Main()
	{
		Vec2f a = .(1,2);
		Vec2f b = .(4,5);

		let c = a.Dot(b);

		Console.WriteLine(c);
		Console.Read();
	}
}