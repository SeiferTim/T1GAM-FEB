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
	public var heart:MeatBagHeart;
	private var _bounceAmt:Float = 2;
	private var _bounceStep:Float = 0;
	public var twnBounce:FlxTween;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		immovable = true;
		makeGraphic(16, 16, 0xffFFEDFD);
		heart = new MeatBagHeart(0, 0);
		add(heart);
		twnBounce = FlxTween.multiVar(this, { _bounceStep:4 }, .1, { type:FlxTween.PINGPONG, ease:FlxEase.quartOut } );
		twnBounce.percent = FlxRandom.floatRanged(0, 1);
		
	}
	
	override public function update():Void 
	{
		relativeY = -_bounceStep * _bounceAmt;
		
		super.update();
	}
	
	
}