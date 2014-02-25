package ;

import flixel.addons.display.FlxNestedSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxAngle;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVelocity;

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
	private var _runTimer:Float = 0;
	private var _shadow:MeatBagShadow;
	private var _dying:Bool = false;
	private var _twnDeath:FlxTween;
	private var _delay:Float = ACTION_DELAY;
	private var _adjust:Float = 0;
	private var _adjustDelay:Float = 0;
	private var _isReal:Bool = true;
	private var _target:MeatBag;
	private var _state:String = "";
	public var pointer:Pointer = null;
	

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(16, 16, 0x0);
		width = 8;
		height = 8;
		offset.x = 4;
		offset.y = 4;
		_runTimer = 0;
		_brain = new FSM();
		_brain.setState(idle);
		
		_target = null;
		
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
	
	private function findTarget():Bool
	{
		var living:Array<MeatBag> = new Array<MeatBag>();
		var m:MeatBag;
		for (i in Reg.playState.grpMeat.members)
		{
			m = cast(i, MeatBag);
			if (m != this && m.alive && m.exists && !m.dying && m.fear < 75 )
			{
				living.push(m);
			}
		}

		if (living.length > 0)
		{
			_target = FlxArrayUtil.getRandom(living);
			return true;
		}
		return false;
	}
	
	private function flock():Void
	{
		_state = "flock";
		// try to move towards other meatbags
		if (!checkForPlayer())
		{
			
			changeFear( -FlxG.elapsed * .5);
			if (_target != null)
			{
				
				if (_target.alive && _target.exists && !_target.dying)
				{
					// move to target
					
					
					FlxVelocity.moveTowardsObject(this, _target, _speed);
					
					
					if (_runTimer > 8 || FlxMath.distanceBetween(this, _target) < 8)
					{
						_target = null;
						chooseAction();
					}
					else
					{	
						_runTimer += FlxG.elapsed * FlxRandom.intRanged(1,5);
					}
					return;
				}
			}
			chooseAction();
		}
	}
	
	private function checkForPlayer():Bool
	{
		if (FlxMath.getDistance(getMidpoint(), Reg.playState.player.getMidpoint()) <= SCARE_RANGE)
		{
			if (_delay <= 0)
			{
				_target = null;
				_brain.setState(flee);
				flee();
				return true;
			}
			else
			{
				_delay -= FlxG.elapsed * FlxRandom.floatRanged(.01,1) * 2;
				//return true;
			}
			
		}
		else
			_delay = ACTION_DELAY;
		return false;
	}
	
	private function idle():Void
	{
		_state = "idle";
		if (!checkForPlayer())
		{
			changeFear( -FlxG.elapsed * .5);
			velocity.x = 0;
			velocity.y = 0;
			if (_runTimer > 6)
			{				
				chooseAction();
			}
			else
			{	
				_runTimer += FlxG.elapsed * FlxRandom.intRanged(1,5);
			}
			
		}
	}
	
	private function chooseAction():Void
	{
		_runTimer = 0;
		if (FlxRandom.chanceRoll(10 + (_fear / 3)))
		{
			if (findTarget())
			{
				_brain.setState(flock);
				return;
			}
		}
		else if (FlxRandom.chanceRoll(5*(_fear/100)))
		{
			var minX:Float = Math.min(x,FlxG.width - x);
			var minY:Float = Math.min(y, FlxG.height - y);
			
			if (Math.abs(minX) < Math.abs(minY))
			{
				// run left or right
				if (minX < FlxG.width / 2)
					_dir = 180;
				else 
					_dir = 0;
			}
			else
			{
				// run up or down
				if (minY < FlxG.height / 2)
					_dir = -90;
				else 
					_dir = 90;
			}
			_brain.setState(escape);
			return;
		}
		else if (FlxRandom.chanceRoll(10))
		{
			_brain.setState(idle);
			return;
		}
		
		_dir = FlxRandom.intRanged(0, 3) * 90;
		_brain.setState(wander);
	}

	private function changeFear(Value:Float):Void
	{
		_fear += Value;
		if (_fear < 0) 
			_fear = 0;
		if (_fear >= 100)
		{
			_dying = true;
			// heart bursts!
			//head.animation.frameIndex = 1;
			head.dying = true;
			_body.bang.visible = false;
			_body.animation.paused = true;
			Reg.playState.particleBurst(_body.heart.x + 4, _body.heart.y + 4, z, getMidpoint(), ZEmitterExt.STYLE_BLOOD);
			_body.heart.kill();
			FlxG.sound.play("kill",.5);
			velocity.x = 0;
			velocity.y = 0;
			acceleration.x = 0;
			acceleration.y = 0;
			_twnDeath = FlxTween.color(this, .66, 0x00ffffff, 0xffffffff, 1, 0, { type:FlxTween.ONESHOT, ease:FlxEase.circIn, complete:goDie } );
		}
		
	}
	
	private function wander():Void
	{
		_state = "wander";
		if (!checkForPlayer())
		{
			changeFear( -FlxG.elapsed * .5);
			
			var v = FlxAngle.rotatePoint(_speed *.8, 0, 0, 0, _dir);
			velocity.x = v.x;
			velocity.y = v.y;
			
			if (_runTimer > 4)
			{
				chooseAction();
			}
			else
			{
				_runTimer += FlxG.elapsed * FlxRandom.intRanged(1,5);
			}
		}
	}
	
	private function escape():Void
	{
		_state = "escape";
		if (!checkForPlayer())
		{
			changeFear(FlxG.elapsed * 4);
			var v = FlxAngle.rotatePoint(_speed *.8, 0, 0, 0, _dir);
			velocity.x = v.x;
			velocity.y = v.y;
			
		}
	}
	
	private function flee():Void
	{
		_state = "flee";
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
		
		_body.bang.visible = true;
		_body.bang.animation.play("scared");
		if (_fear >= 70)
			_body.bang.animation.play("dying");
		
		var _dist:Float = FlxMath.getDistance(getMidpoint(), Reg.playState.player.getMidpoint());
		if (_dist > SCARE_RANGE)
		{
			if (_delay <= 0)
			{
				_body.bang.visible = false;
				chooseAction();
				_adjustDelay = 0;
			}
			else 
				_delay -= FlxG.elapsed * FlxRandom.floatRanged(0, 1);
		}
		else 
		{
			_delay = ACTION_DELAY;
			changeFear(((SCARE_RANGE - _dist) / (SCARE_RANGE)) * 4);
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
					FlxG.sound.play("escape",.25);
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
			
			if ((justTouched(FlxObject.UP) && justTouched(FlxObject.LEFT)) || (justTouched(FlxObject.UP) && justTouched(FlxObject.RIGHT)) || (justTouched(FlxObject.DOWN) && justTouched(FlxObject.LEFT)) || (justTouched(FlxObject.DOWN) && justTouched(FlxObject.RIGHT)))
			{
				_dir = FlxAngle.wrapAngle(_dir + 180);
				if (Math.abs(velocity.x) < Math.abs(velocity.y))
					velocity.y *= -1;
				else
					velocity.x *= -1;
			}
			else
			{
				if (justTouched(FlxObject.LEFT) || justTouched(FlxObject.RIGHT) && Math.abs(velocity.x) > Math.abs(velocity.y))
				{
					_dir = FlxAngle.wrapAngle(_dir + 180);
					if (Math.abs(velocity.y) > 1)
						velocity.y *= 2;
					else
						velocity.y *= 5;
				}
				
				if (justTouched(FlxObject.UP) || justTouched(FlxObject.DOWN) && Math.abs(velocity.x) < Math.abs(velocity.y))
				{
					_dir = FlxAngle.wrapAngle(_dir + 180);
					if (Math.abs(velocity.x) > 1)
						velocity.x *= 2;
					else
						velocity.x *= 5;
				}
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
				//head.animation.frameIndex = 0;
			case FlxObject.LEFT:
				head.relativeX = _body.relativeX - head.width + 2; 
				head.relativeY = _body.relativeY - 2;
				head.z = 15;
				//head.animation.frameIndex = 2;
			case FlxObject.DOWN:
				head.relativeX = _body.relativeX + (_body.width/2) - (head.width/2);
				head.relativeY = _body.relativeY + 2;
				head.z = 15;
				//head.animation.frameIndex = 0;
			case FlxObject.UP:
				head.relativeX = _body.relativeX + (_body.width/2) - (head.width/2);
				head.relativeY = _body.relativeY - 4;
				head.z = 5;
				//head.animation.frameIndex = 2;
		}
		
		_body.heart.duration = .2 * ((100 - _fear) / 80);
		children.sort(sortZ);
		
		if (pointer != null)
		{
			var mp:FlxPoint = getMidpoint();
			if ((mp.x > 64 && mp.x < FlxG.width - 64) && (mp.y > 64 && mp.y < FlxG.height - 64))
			{
				pointer.kill();
				pointer = null;
			}
			else
			{
				pointer.target.x = mp.x;
				pointer.target.y = mp.y;
			}
			
		}
		
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
	
	override public function kill():Void 
	{
		if(pointer!=null)
		{
			pointer.kill();
			pointer = null;
		}
		super.kill();
	}
	
}