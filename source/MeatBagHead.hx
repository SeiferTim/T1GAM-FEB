package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.FlxObject;

/**
 * ...
 * @author 
 */
class MeatBagHead extends DisplaySprite
{
	
	public var dying:Bool = false;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		//makeGraphic(8, 8, 0xffFFEDFD);
		loadGraphic("assets/images/head-new.png", true, true, 8, 8);
		animation.add("alive-lr", [0,1], 4, true);
		animation.add("dead-lr", [2], 1, false);
		animation.add("alive-d", [3,4], 4, true);
		animation.add("dead-d", [5], 1, false);
		animation.add("alive-u", [6,7], 4, true);
		animation.add("dead-u", [8], 1, false);
		
		//animation.add("alive-right", [2], 1, false);
		//animation.add("dead-right", [3], 1, false);
		
		
		//animation.play("alive");
	
		
		//animation.frameIndex = 0;
		//animation.play("alive");
	}
	
	override public function update():Void 
	{
		if (facing == FlxObject.LEFT || facing == FlxObject.RIGHT) 
		{
			if (!dying && animation.name != "alive-lr")
				animation.play("alive-lr", true);
			else if (dying && animation.name != "dead-lr")
				animation.play("dead-lr", true);
		}
		else if (facing == FlxObject.UP )
		{
			if (!dying  && animation.name != "alive-u")
				animation.play("alive-u", true);
			else if (dying && animation.name != "dead-u")
				animation.play("dead-u", true);
		}
		else if (facing == FlxObject.DOWN)
		{
			if (!dying && animation.name != "alive-d")
				animation.play("alive-d", true);
			else if (dying && animation.name != "dead-d")
				animation.play("dead-d", true);
		}
		super.update();
	}
	
}