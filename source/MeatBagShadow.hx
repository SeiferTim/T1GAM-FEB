package ;

import flixel.addons.display.FlxNestedSprite;

/**
 * ...
 * @author 
 */
class MeatBagShadow extends FlxNestedSprite
{

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/shadow.png", false, false);
		relativeY = 2;
		
	}
	
}