package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;

/**
 * ...
 * @author 
 */
class MeatBag extends FlxNestedSprite
{

	private var _fear:Float = 0;
	private var _body:MeatBody;
	private var _brain:FSM;
	private var _speed:Int = 100;
	private var _dir:Int;
	private var _runTimer:Float;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic("assets/images/shadow.png", false, false, 16, 16, false, "shadow");
		width = 16;
		height = 16;
		
		_brain = new FSM();
		_brain.setState(idle);
		_body = new MeatBody(X, Y);
		add(_body);
		
	}
	
	private function idle():Void
	{
		velocity.x = 0;
		velocity.y = 0;
		if (FlxRandom.chanceRoll(2))
		{
			_runTimer = 0;
			_dir = FlxRandom.intRanged(0, 3) * 90;
			_brain.setState(wander);
		}
	}
	
	private function wander():Void
	{
		var v = FlxAngle.rotatePoint(_speed, 0, 0, 0, _dir);
		velocity.x = v.x;
		velocity.y = v.y;
		
		if (_runTimer > 3)
			_brain.setState(idle);
		else
		{
			_runTimer += FlxG.elapsed * FlxRandom.intRanged(1,5);
		}
	}
	
	override public function update():Void 
	{
		_brain.update();
		
		super.update();
	}
	
}