package ;

import flixel.addons.display.FlxNestedSprite;


class MeatBagBang extends FlxNestedSprite
{

	public function new() 
	{
		super(0, 0);
		loadGraphic("assets/images/bang.png", true, false, 16, 16);
		animation.add("scared", [0, 1], 4);
		animation.add("dying", [2, 3], 8);
		animation.play("scared");
		relativeX = -16;
		relativeY = -16;
		
	}
	
}