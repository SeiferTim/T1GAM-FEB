package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;

class Pointer extends FlxSprite
{

	private var _angle:Int;
	
	public static var A_0:Int = 9;
	public static var A_45:Int = 15;
	public static var A_90:Int = 11;
	public static var A_135:Int = 14;
	public static var A_180:Int = 8;
	public static var A_225:Int = 12;
	public static var A_270:Int = 10;
	public static var A_315:Int = 13;
	
	public var target:FlxPoint;
	
	private var _twn:FlxTween;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(0, 0);
		loadGraphic("assets/images/pointer.png", true, false, 16, 16);
		kill();
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		target = new FlxPoint(X, Y);
		
		super.reset(X, Y);
		
		_twn = FlxTween.singleVar(this, "alpha", .2, .1, { type:FlxTween.PINGPONG, ease:FlxEase.quintInOut } );
		
		draw();
	
	}
	
	
	override public function draw():Void 
	{
		
		var _tarX:Float=target.x;
		var _tarY:Float=target.y;
		
		if (target.x < 64)
		{
			if (target.y < 64)
			{
				_angle = A_225;
				_tarX = target.x + 8;
				_tarY = target.y + 8;
			}
			else if (target.y > FlxG.height - 64)
			{
				_angle = A_135;
				_tarX = target.x + 8;
				_tarY = target.y - 24;
			}
			else
			{
				_angle = A_180;
				_tarX = target.x + 8;
				_tarY = target.y - 8;
			}
		}
		else if (target.x > FlxG.width - 64)
		{
			if (target.y < 64)
			{
				_angle = A_315;
				_tarX = target.x - 24;
				_tarY = target.y + 8;
			}
			else if (target.y > FlxG.height - 64)
			{
				_angle = A_45;
				_tarX = target.x - 24;
				_tarY = target.y - 24;
			}
			else
			{
				_angle = A_0;
				_tarX = target.x - 24;
				_tarY = target.y - 8;
			}
		}
		else if (target.y < 64)
		{
			_angle = A_270;
			_tarX = target.x - 8;
			_tarY = target.y + 8;
		}
		else if (target.y > FlxG.height - 64)
		{
			_angle = A_90;
			_tarX = target.x - 8;
			_tarY = target.y - 24;
		}
		
		
		animation.frameIndex = _angle;
		
		x = _tarX;
		y = _tarY;
		
		super.draw();
	}
	
	
}