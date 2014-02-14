package ;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

class TitleLetter extends FlxSprite
{
	public static var LETTER_M:Int = 0;
	public static var LETTER_E:Int = 1;
	public static var LETTER_A:Int = 2;
	public static var LETTER_T:Int = 3;
	public static var LETTER_B:Int = 4;
	public static var LETTER_G:Int = 5;
	public static var LETTER_S:Int = 6;
	
	private var _twnFall:FlxTween;
	private var _twnBob:FlxTween;
	private var _tmr:FlxTimer;
	private var _floor:Float;
	
	public function new(X:Float = 0, Y:Float = 0, Letter:Int = 0, Floor:Float = 0, Delay:Float = 0) 
	{
		super(X, Y);
		loadGraphic("assets/images/title-font.png", true, false, 50, 50);
		animation.frameIndex = Letter;
		_floor = Floor;
		_tmr = FlxTimer.start(Delay, doneDelay);
		
		
		
	}
	
	private function doneDelay(T:FlxTimer):Void
	{
		_twnFall = FlxTween.singleVar(this, "y", _floor, 1, { type:FlxTween.ONESHOT, ease:FlxEase.elasticOut, complete:doneFall } );
	}
	
	private function doneFall(T:FlxTween):Void
	{
		_twnBob = FlxTween.singleVar(this, "y", _floor - 25, .66, { type:FlxTween.PINGPONG, ease:FlxEase.quadInOut } );
	}
	
}