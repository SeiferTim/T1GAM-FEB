package ;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class EnergyPickupBody extends DisplaySprite
{

	private var _twn:FlxTween;
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		//makeGraphic(8, 8, 0xff00cccc);
		loadGraphic("assets/images/energy-pickup.png", false, false, 8, 8);
		relativeX = 4;
		relativeY = 8;
		_twn = FlxTween.singleVar(this, "relativeY",0, .6, {type:FlxTween.PINGPONG, ease:FlxEase.circInOut } );
	}
	
}