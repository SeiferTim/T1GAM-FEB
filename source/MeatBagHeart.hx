package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.util.FlxTimer;

class MeatBagHeart extends FlxNestedSprite
{

	public var duration:Float = .2;
	private var _tmr:FlxTimer;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);

		loadGraphic("assets/images/heart.png", true, true, 8, 8);

		animation.frameIndex = 0;
		relativeX = 4;
		relativeY = -4;

		forceComplexRender = true;

		_tmr = FlxTimer.start(duration, beat, 1);
	}
	
	override public function update():Void 
	{
		if (!alive || !exists || !visible) 
			return;

		super.update();
	}
	
	private function beat(T:FlxTimer):Void
	{
		if (!alive || !exists || !visible) 
			return;
		if (animation.frameIndex == 0)
			animation.frameIndex = 1;
		else
			animation.frameIndex = 0;
		T.reset(duration);
		
	}
	
	
	
}