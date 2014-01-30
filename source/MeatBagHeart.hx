package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;

/**
 * ...
 * @author 
 */
class MeatBagHeart extends FlxNestedSprite
{

	public var twn:FlxTween;
	private var _tscale:Float = .6;
	public var duration:Float = .2;
			
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(8, 8, 0xffff0000);
		relativeX = 4;
		relativeY = -4;
		relativeScaleX = relativeScaleY = _tscale;
		forceComplexRender = true;
		twn = FlxTween.multiVar(this, { _tscale:1.6 }, duration, { type:FlxTween.PINGPONG, ease:FlxEase.bounceInOut } );
		twn.percent = FlxRandom.floatRanged(0, 1);
	}
	
	override public function update():Void 
	{
		if (!alive || !exists || !visible) return;
		relativeScaleX = relativeScaleY = _tscale;
		twn.duration = duration;
		super.update();
	}
	
	
	
}