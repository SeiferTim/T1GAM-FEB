package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

/**
 * ...
 * @author 
 */
class MeatBag extends DisplaySprite
{
	private inline static var SCARE_RANGE:Int = 100;
	private var _fear:Float = 0;
	private var _body:MeatBody;
	private var _brain:FSM;
	private var _speed:Int = 100;
	private var _dir:Int;
	private var _runTimer:Float;
	private var _shadow:MeatBagShadow;
	private var _dying:Bool = false;
	private var _twnDeath:FlxTween;
	
	
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(16, 16, 0x0);
		width = 16;
		height = 16;
		
		_brain = new FSM();
		_brain.setState(idle);
		
		_shadow = new MeatBagShadow(X, Y);
		add(_shadow);
		_body = new MeatBody(X, Y);
		add(_body);
		
		//FlxG.watch.add(this, "_fear");
		
	}
	
	private function idle():Void
	{
		if (FlxMath.getDistance(getMidpoint(), Reg.playState.player.getMidpoint()) <= SCARE_RANGE)
		{
			_brain.setState(flee);
			flee();
		}
		else
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
	}
	

	
	private function wander():Void
	{
		if (FlxMath.getDistance(getMidpoint(), Reg.playState.player.getMidpoint()) <= SCARE_RANGE)
		{
			_brain.setState(flee);
			flee();
		}
		else
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
	}
	
	private function flee():Void
	{
		var a:Float = FlxAngle.angleBetween(Reg.playState.player, this, true);
		var v:FlxPoint = FlxAngle.rotatePoint(_speed*2, 0, 0, 0, a);
		velocity.x = v.x;
		velocity.y = v.y;
		
		var _dist:Float = FlxMath.getDistance(getMidpoint(), Reg.playState.player.getMidpoint());
		if (_dist > SCARE_RANGE)
		{
			_fear = 0;
			_brain.setState(idle);
		}
		else 
		{
			_fear = (SCARE_RANGE - _dist) / (SCARE_RANGE * 5);
			

		}
		_body.heart.duration = .2 - _fear;
		if (_body.heart.duration < FlxG.elapsed*4)
		{
			_dying = true;
			// heart bursts!
			Reg.playState.heartBurst(_body.heart.x + 4, _body.heart.y + 4, z);
			_body.heart.kill();
			
			velocity.x = 0;
			velocity.y = 0;
			acceleration.x = 0;
			acceleration.y = 0;
			_twnDeath = FlxTween.color(this, 2, 0xffffffff, 0xff0000ff, 1, 0, { type:FlxTween.ONESHOT, ease:FlxEase.circIn, complete:goDie } );
		}
		
	}
	
	override public function update():Void 
	{
		if (!_dying)
		{
			_brain.update();

		}
		else
		{
			if (_body.twnBounce.type != FlxTween.ONESHOT && _body.twnBounce.backward) 
				_body.twnBounce.type = FlxTween.ONESHOT;
			
		}
		super.update();
		_shadow.relativeScaleX = 1.25 + (_body.relativeY / 10);
		
	}
	
	private function goDie(T:FlxTween):Void
	{
		kill();
	}
	
	function get_fear():Float 
	{
		return _fear;
	}
	
	function set_fear(value:Float):Float 
	{
		return _fear = value;
	}
	
	public var fear(get_fear, set_fear):Float;
	
}