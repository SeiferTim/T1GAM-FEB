package ;

import flixel.addons.display.FlxNestedSprite;

/**
 * ...
 * @author 
 */
class DisplaySprite extends FlxNestedSprite
{

	private var _z:Float = 0;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
	}
	
	function get_z():Float 
	{
		return y+height;
	}
	
	public var z(get_z, null):Float;
	
	
	
}