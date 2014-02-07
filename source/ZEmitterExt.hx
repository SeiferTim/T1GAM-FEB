package ;

import flixel.effects.particles.FlxEmitterExt;

class ZEmitterExt extends FlxEmitterExt
{
	public var z:Float;
	
	public function new(X:Float=0, Y:Float=0, Size:Int=0) 
	{
		super(X, Y, Size);	
	}
	
}