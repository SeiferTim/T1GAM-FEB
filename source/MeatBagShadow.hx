package ;

import flixel.addons.display.FlxNestedSprite;

class MeatBagShadow extends DisplaySprite
{
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/shadow.png", false, false);
		relativeY = 2;
		
	}
	
}