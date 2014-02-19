package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.FlxObject;

/**
 * ...
 * @author 
 */
class MeatBagHead extends DisplaySprite
{
	
	
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		//makeGraphic(8, 8, 0xffFFEDFD);
		loadGraphic("assets/images/head.png", true, true, 8, 8);
		animation.add("alive", [0], 1, false);
		animation.add("dead", [1], 1, false);
		//animation.add("alive-right", [2], 1, false);
		//animation.add("dead-right", [3], 1, false);
		
		
		//animation.play("alive");
	
		
		//animation.frameIndex = 0;
		animation.play("alive");
	}
	
	override public function update():Void 
	{
		
		super.update();
	}
	
}