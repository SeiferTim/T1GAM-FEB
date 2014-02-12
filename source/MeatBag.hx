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
	private var _adjust:Float = 0;
	private var _adjustDelay:Float = 0;
	private var _isReal:Bool = true;
	

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(16, 16, 0x0);
		width = 8;
		height = 8;
		offset.x = 4;
		offset.y = 4;
		
		_brain = new FSM();
		_brain.setState(idle);
		
		_shadow = new MeatBagShadow(X, Y);
		_shadow.calcZ = false;
		_shadow.z = 0;
		add(_shadow);
		_body = new MeatBody(X, Y);
		_body.calcZ = false;
		_body.z = 10;
		add(_body);
		
		head = new MeatBagHead(X, Y);
		head.calcZ = false;
		head.z = 15;
		
		add(head);
		
		
		var dirs:Array<Int> = [FlxObject.UP, FlxObject.DOWN, FlxObject.RIGHT, FlxObject.LEFT];
		facing = FlxRandom.getObject(dirs);
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
			if (FlxRandom.chanceRoll(1))
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
			var v = FlxAngle.rotatePoint(_speed *.8, 0, 0, 0, _dir);
			velocity.x = v.x;
			velocity.y = v.y;
			
			if (_runTimer > 2)
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
		if (_adjustDelay <= 0)
		{
			_adjustDelay = 1 + FlxRandom.floatRanged( -1, 1);
			_adjust = FlxRandom.intRanged( -30, 30);
		}
		else
			_adjustDelay -= FlxG.elapsed;
		
		a += _adjust;
		a  = FlxAngle.wrapAngle(a);
		
		var v:FlxPoint = FlxAngle.rotatePoint(_speed * 4, 0, 0, 0, a);
			
		velocity.x = v.x;
		velocity.y = v.y;
		
		var _dist:Float = FlxMath.getDistance(getMidpoint(), Reg.playState.player.getMidpoint());
		if (_dist > SCARE_RANGE)
		{
			if (_delay <= 0)
			{
				_fear = 0;
				_brain.setState(idle);
				_adjustDelay = 0;
			}
			else 
				_delay -= FlxG.elapsed * FlxRandom.floatRanged(0, 1);
		}
		else 
		{
			_delay = ACTION_DELAY;
			_fear = (SCARE_RANGE - _dist) / (SCARE_RANGE * 3);
		}
		_body.heart.duration = .2 - _fear;
		if (_body.heart.duration < FlxG.elapsed*5)
		{
			_dying = true;
			// heart bursts!
			Reg.playState.particleBurst(_body.heart.x + 4, _body.heart.y + 4, z, getMidpoint(), ZEmitterExt.STYLE_BLOOD);
			_body.heart.kill();
			FlxG.sound.play("kill");
			velocity.x = 0;
			velocity.y = 0;
			acceleration.x = 0;
			acceleration.y = 0;
			_twnDeath = FlxTween.color(this, .66, 0x00ffffff, 0xffffffff, 1, 0, { type:FlxTween.ONESHOT, ease:FlxEase.circIn, complete:goDie } );
		}
		
	}
	
	override public function update():Void 
	{
		if (_isReal)
		{
			if (!_dying)
			{
				if (!isOnScreen() && alive && exists)
				{	
					
					Reg.playState.particleBurst(_body.heart.x + 4, _body.heart.y + 4, z, getMidpoint(), ZEmitterExt.STYLE_CLOUD);
					FlxG.sound.play("escape");
					kill();
					return;
				}
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
		}
		
		switch(facing)
		{
			case FlxObject.RIGHT:
				head.relativeX =  _body.relativeX + _body.width - 2;
				head.relativeY = _body.relativeY - 2;
				head.z = 15;
			case FlxObject.LEFT:
				head.relativeX = _body.relativeX - head.width + 2; 
				head.relativeY = _body.relativeY - 2;
				head.z = 15;
			case FlxObject.DOWN:
				head.relativeX = _body.relativeX + (_body.width/2) - (head.width/2);
				head.relativeY = _body.relativeY + 2;
				head.z = 15;
			case FlxObject.UP:
				head.relativeX = _body.relativeX + (_body.width/2) - (head.width/2);
				head.relativeY = _body.relativeY - 4;
				head.z = 5;
		}
		
		
		children.sort(sortZ);
		
		super.update();
		_shadow.relativeScaleX = 1.25 + (_body.relativeY / 10);
		
	}
	
	private function sortZ(O1:FlxNestedSprite, O2:FlxNestedSprite):Int
	{
		
		var MBX:DisplaySprite = cast O1;
		var MBY:DisplaySprite = cast O2;
		
		
		
		if (MBX.z < MBY.z)
			return -1;
		else if (MBX.z > MBY.z)
			return 1;
		else
			return 0;
		
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
	
	private function set_isReal(value:Bool):Bool 
	{
		return _isReal = value;
	}
	
	public var isReal(null, set_isReal):Bool;
	
	function get_dying():Bool 
	{
		return _dying;
	}
	
	public var dying(get_dying, null):Bool;
	
}