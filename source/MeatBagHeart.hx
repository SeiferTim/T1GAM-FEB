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

	private var _twn:FlxTween;
	private var _tscale:Float = .6;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(8, 8, 0xffff0000);
		relativeX = 4;
		relativeY = -4;
		relativeScaleX = relativeScaleY = _tscale;
		forceComplexRender = true;
		
		_twn = FlxTween.multiVar(this, { _tscale:1.6 }, .2, { type:FlxTween.PINGPONG, ease:FlxEase.bounceInOut } );
		_twn.percent = FlxRandom.floatRanged(0, 1);
	}
	
	override public function update():Void 
	{
		relativeScaleX = relativeScaleY = _tscale;
		super.update();
	}
	
}