package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;

/**
 * ...
 * @author 
 */
class MeatBody extends FlxNestedSprite
{
	private var _heart:MeatBagHeart;
	private var _bounceAmt:Float = 2;
	private var _bounceStep:Float = 0;
	private var _twnBounce:FlxTween;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		immovable = true;
		makeGraphic(16, 16, 0xffFFEDFD);
		_heart = new MeatBagHeart(0,0);
		add(_heart);
		_twnBounce = FlxTween.multiVar(this, { _bounceStep:4 }, .1, { type:FlxTween.PINGPONG, ease:FlxEase.quartOut } );
		_twnBounce.percent = FlxRandom.floatRanged(0, 1);
	}
	
	override public function update():Void 
	{
		relativeY = -_bounceStep * _bounceAmt;
		
		super.update();
	}
	
}