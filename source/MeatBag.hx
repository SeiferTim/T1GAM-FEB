package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import lime.InputHandler.ButtonState;

/**
 * ...
 * @author 
 */
class MeatBag extends DisplaySprite
{
	private inline static var SCARE_RANGE:Int = 100;
	private inline static var ACTION_DELAY:Float = .066;
	private inline static var _speed:Int = 100;
	private var _fear:Float = 0;
	private var _body:MeatBody;
	private var _brain:FSM;
	public var head:MeatBagHead;
	private var _dir:Int;
	private var _runTimer:Float;
	private var _shadow:MeatBagShadow;
	private var _dying:Bool = false;
	private var _twnDeath:FlxTween;
	private var _delay:Float = ACTION_DELAY;

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(16, 16, 0x0);
		width = 16;
		height = 16;
		
		_brain = new FSM();
		_brain.setState(idle);
		
		_shadow = new MeatBagShadow(X, Y);
		_shadow.z = 0;
		add(_shadow);
		_body = new MeatBody(X, Y);
		_body.z = 10;
		add(_body);
		
		head = new MeatBagHead(X, Y);
		head.z = 15;
		add(head);
		
		//var dirs:Array<Int> = [FlxObject.UP, FlxObject.DOWN, FlxObject.RIGHT, FlxObject.LEFT];
		//facing = FlxRandom.getObject(dirs);
	}
	
	private function idle():Void
	{
		if (FlxMath.getDistance(getMidpoint(), Reg.playState.player.getMidpoint()) <= SCARE_RANGE)
		{
			if (_delay <= 0)
			{
				_brain.setState(flee);
				flee();
			}
			else
				_delay -= FlxG.elapsed * FlxRandom.floatRanged(0, 1) * 6;
		}
		else
		{
			_delay = ACTION_DELAY;
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
			if (_delay <= 0)
			{
				_brain.setState(flee);
				flee();
			}
			else
				_delay -= FlxG.elapsed * FlxRandom.floatRanged(0, 1) * 6;
		}
		else
		{
			_delay = ACTION_DELAY;
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
		a += FlxRandom.intRanged( -30, 30);
		a  = FlxAngle.wrapAngle(a);
		var v:FlxPoint = FlxAngle.rotatePoint(_speed * 4, 0, 0, 0, a);
		
		/*
		if ((isTouching(FlxObject.LEFT) && v.x < 0) || (isTouching(FlxObject.RIGHT) && v.x > 0))
			v.x *= -1;
		if ((isTouching(FlxObject.UP) && v.y < 0) || (isTouching(FlxObject.DOWN) && v.y > 0))
			v.y *= -1;
		*/
			
		velocity.x = v.x;
		velocity.y = v.y;
		
		var _dist:Float = FlxMath.getDistance(getMidpoint(), Reg.playState.player.getMidpoint());
		if (_dist > SCARE_RANGE)
		{
			if (_delay <= 0)
			{
			_fear = 0;
			_brain.setState(idle);
			}
			else 
				_delay -= FlxG.elapsed * FlxRandom.floatRanged(0, 1);
		}
		else 
		{
			_delay = ACTION_DELAY;
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
		
		if (velocity.x > 0 && Math.abs(velocity.x) > Math.abs(velocity.y))
		{
			facing = FlxObject.RIGHT;
			
		}
		else if (velocity.x < 0 && Math.abs(velocity.x) > Math.abs(velocity.y))
		{
			facing = FlxObject.LEFT;
			
		}
		else if (velocity.y > 0)
		{
			facing = FlxObject.DOWN;
			
		}
		else if (velocity.y < 0)
		{
			facing = FlxObject.UP;
		}
			
		switch(facing)
		{
			case FlxObject.RIGHT:
				head.relativeX =  _body.relativeX - width - 2;
				head.relativeY = _body.relativeY - 2;
				head.z = 15;
			case FlxObject.LEFT:
				head.relativeX = _body.relativeX - 6;
				head.relativeY = _body.relativeX - 2;
				head.z = 15;
			case FlxObject.DOWN:
				head.relativeX = _body.relativeX + 2;
				head.relativeY = _body.relativeY + 2;
				head.z = 15;
			case FlxObject.UP:
				head.relativeX = _body.relativeX + 2;
				head.relativeY = _body.relativeY - 4;
				head.z = 5;
		}
		
		
		//_children.sort(sortZ);
		super.update();
		_shadow.relativeScaleX = 1.25 + (_body.relativeY / 10);
		
	}
	
	/*private function sortZ(O1:FlxNestedSprite, O2:FlxNestedSprite):Int
	{
		if (cast(O1,DisplaySprite).z > cast(O2,DisplaySprite).z)
			return 1;
		else if (cast(O1,DisplaySprite).z < cast(O2,DisplaySprite).z)
			return -1;
		else
			return 0;
	}*/
	
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