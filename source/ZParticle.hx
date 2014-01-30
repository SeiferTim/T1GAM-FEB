package ;

import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxRandom;

class ZParticle extends FlxParticle
{

	private var _floor:Float;
	private var _justBounced:Bool = false;
	private var _touchingFloor:Bool = false;
	private var _wasTouchingFloor:Bool = false;
	private var _z:Float;
	public function new() 
	{
		super();
		//elasticity = .6;
		FlxG.watch.add(this, "x");
		FlxG.watch.add(this, "y");
		FlxG.watch.add(this, "touching");
		
	}
	
	override public function update():Void 
	{
		if (alive && exists && active && visible)
		{
			if (y >= _floor)
			{
				velocity.x = 0;
				velocity.y = 0;
			}
			
		}
		super.update();
	}
	
	private function set_floor(value:Float):Float 
	{
		trace(value);
		return _floor = value;
	}
	
	public var floor(null, set_floor):Float;
	
	function get_z():Float 
	{
		return y;
	}
	
	public var z(get_z, null):Float;
	
}