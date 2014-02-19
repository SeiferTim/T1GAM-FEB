package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class MeatBagHeart extends FlxNestedSprite
{

	//public var twn:FlxTween;
	//private var _tscale:Float = .6;
	public var duration:Float = .2;
	private var _tmr:FlxTimer;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		//makeGraphic(8, 8, 0xffff0000);
		loadGraphic("assets/images/heart.png", true, true, 8, 8);
		//animation.add("beat", [0, 1], 4);
		//animation.play("beat");
		animation.frameIndex = 0;
		relativeX = 4;
		relativeY = -4;
		//relativeScaleX = relativeScaleY = _tscale;
		forceComplexRender = true;
		//twn = FlxTween.multiVar(this, { _tscale:1.6 }, duration, { type:FlxTween.PINGPONG, ease:FlxEase.bounceInOut } );
		//twn.percent = FlxRandom.floatRanged(0, 1);
		_tmr = FlxTimer.start(duration, beat, 1);
	}
	
	override public function update():Void 
	{
		if (!alive || !exists || !visible) 
			return;
		//relativeScaleX = relativeScaleY = _tscale;
		//twn.duration = duration;
		
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