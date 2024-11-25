using System;
namespace Osteon.Color;

[Union]
public struct Color32
{
	[Ordered]
	private struct _ { public uint8 A,B,G,R; }

	public uint32 RGBA;
	public using private _ values;

	public this(uint32 rgba)
	{
		RGBA = rgba;
	}

	public this(uint8 r, uint8 g, uint8 b, uint8 a = 0xFF)
	{
		R = r;
		G = g;
		B = b;
		A = a;
	}

	public static explicit operator Self(Color c) => .((uint8)(c.R*255), (uint8)(c.G*255), (uint8)(c.B*255), (uint8)(c.A*255));
	public static implicit operator Color(Self c) => .(c.R/255f, c.G/255f, c.B/255f, c.A/255f);
}