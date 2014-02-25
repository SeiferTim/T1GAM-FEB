package ;

import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;

class MeatBody extends DisplaySprite
{
	public var heart:MeatBagHeart;
	private var _bounceAmt:Float = 2;
	private var _bounceStep:Float = 0;
	public var twnBounce:FlxTween;
	public var bang:MeatBagBang;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		immovable = true;
		//makeGraphic(16, 16, 0xffFFEDFD);
		loadGraphic("assets/images/body-new.png", true, true, 16, 16);
		animation.add("lr", [0, 1], 4);
		animation.add("ud", [2, 3], 4);
		animation.play("lr");
		
		heart = new MeatBagHeart(0, 0);
		add(heart);
		
		bang = new MeatBagBang();
		bang.relativeX = 0;
		bang.relativeY = -8-16;
		add(bang);
		bang.visible = false;
		
		twnBounce = FlxTween.multiVar(this, { _bounceStep:4 }, .1, { type:FlxTween.PINGPONG, ease:FlxEase.quartOut } );
		twnBounce.percent = FlxRandom.floatRanged(0, 1);
		
		
	}
	
	override public function update():Void 
	{
		relativeY = -_bounceStep * _bounceAmt;
		
		if ((facing == FlxObject.LEFT || facing == FlxObject.RIGHT) && animation.name != "lr")
			animation.play("lr", true);
		else if ((facing == FlxObject.UP || facing == FlxObject.DOWN) && animation.name != "ud")
			animation.play("ud", true);
		
		super.update();
	}
	
	
	
}