package ;

import flixel.effects.particles.FlxEmitterExt;

/**
 * ...
 * @author 
 */
class ZEmitterExt extends FlxEmitterExt
{
	private var _z:Float;
	
	public function new(X:Float=0, Y:Float=0, Size:Int=0) 
	{
		super(X, Y, Size);
		
	}
	
	function get_z():Float 
	{
		return _z;
	}
	
	function set_z(value:Float):Float 
	{
		return _z = value;
	}
	
	public var z(get_z, set_z):Float;
	
	
	
}