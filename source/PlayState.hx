package;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.LogitechButtonID;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxCollision;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private static inline var SPEED:Int = 480;
	private static inline var FRICTION:Float = .8;
	
	private var _loading:Bool = true;
	
	public var player:DisplaySprite;
	private var _grpMeat:FlxGroup;
	private var _grpMap:FlxGroup;
	private var _grpDisplayObjs:FlxGroup;
	private var _grpFX:FlxGroup;
	private var _grpHUD:FlxGroup;
	
	private var _grass:FlxSprite;
	private var _map:FlxOgmoLoader;
	private var _walls:FlxTilemap;
	
	private var _emtHeartBurst:ZEmitterExt;
	private var _energy:Float = 100;
	private var _barEnergy:FlxBar;
	private var _twnBar:FlxTween;
	private var _barFadingOut:Bool = false;
	private var _barFadingIn:Bool = false;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		Reg.playState = this;
		
		_grpDisplayObjs = new FlxGroup();
		
		_grpMap = new FlxGroup();
		_grpMeat = new FlxGroup();
		_grpFX = new FlxGroup();
		_grpHUD = new FlxGroup();
		
		player = new DisplaySprite(0, 0);
		player.makeGraphic(32, 32, 0xff1F64B1);
		
		_grass = FlxGridOverlay.create(64, 64, FlxG.width, FlxG.height,false, true, 0xff77C450, 0xff2A9D0C);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		_grpMap.add(_grass);
		
		player.x = (FlxG.width - player.width) / 2;
		player.y = (FlxG.height - player.height) / 2;
		player.forceComplexRender = true;
		
		_map = new FlxOgmoLoader("assets/data/level-0001.oel");
		_walls = _map.loadTilemap("assets/images/walls.png", 16, 16, "walls");
		FlxSpriteUtil.screenCenter(_walls, true, true);
		trace(_walls.x + " " + _walls.y);
		_map.loadEntities(loadEntity, "meats");
		
		_grpMap.add(_walls);
		
		add(_grpMap);
		add(_grpDisplayObjs);
		_grpDisplayObjs.add(player);
		add(_grpFX);
		add(_grpHUD);
		
		_barEnergy = new FlxBar(0, FlxG.height - 24, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * .6), 16, this, "_energy", 0, 100, true);
		_barEnergy.createFilledBar(0xff006666, 0xff00ffff, true, 0xff003333);
		FlxSpriteUtil.screenCenter(_barEnergy, true, false);
		_grpHUD.add(_barEnergy);
		
		
		
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, true, fadeInDone);
		
		super.create();
	}
	
	private function loadEntity(EType:String, EXml:Xml):Void
	{
		var mB:MeatBag = new MeatBag(Std.parseFloat(EXml.get("x")), Std.parseFloat(EXml.get("y")));
		_grpMeat.add(mB);
		_grpDisplayObjs.add(mB);
	}
	
	private function fadeInDone():Void
	{
		_loading = false;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (_loading)
		{
			super.update();
			return;
		}
		
		playerMovement();
		
		super.update();
		
		FlxG.collide(player, _walls);
		FlxG.collide(_grpMeat, _grpMeat);
		FlxG.collide(_grpMeat, _walls);
		
		_energy -=FlxG.elapsed * 3;
		
		if (player.y > FlxG.height - player.height - 40 && player.x - player.width > 32 && player.x < FlxG.height - 32)
			fadeOutEnergyBar();
		else
			fadeInEnergyBar();
		
		_grpDisplayObjs.sort("z");
		
	}	
	
	private function fadeOutEnergyBar():Void
	{
		if (_barFadingOut)
			return;
		_barFadingOut = true;
		if (_barFadingIn)
			_twnBar.cancel();
		_barFadingIn = false;
		_twnBar = FlxTween.multiVar(_barEnergy, { alpha:.2 }, .2, { type:FlxTween.PERSIST, complete:finishBarFadeOut } );
		
	}
	
	private function finishBarFadeOut(T:FlxTween):Void
	{
		_barFadingOut = false;
	}
	
	private function fadeInEnergyBar():Void
	{
		if (_barFadingIn)
			return;
		_barFadingIn = true;
		if (_barFadingOut)
			_twnBar.cancel();
		_barFadingOut = false;
		_twnBar = FlxTween.multiVar(_barEnergy, { alpha:1 }, .2, { type:FlxTween.PERSIST, complete:finishBarFadeIn } );
	
	}
	
	private function finishBarFadeIn(T:FlxTween):Void
	{
		_barFadingIn = false;
	}
	
	public function heartBurst(X:Float, Y:Float, Floor:Float):Void
	{
		var h:ZEmitterExt=null;
		
		for (o in _grpDisplayObjs.members)
		{
			if (Type.getClassName(Type.getClass(o)) == "ZEmitterExt")
			{
				if (cast(o, ZEmitterExt).countLiving() == 0)
				{
					h = cast(o, ZEmitterExt);
					trace("revival!");
					break;
				}
			}
		}
		
		if (h == null)
		{
			h = new ZEmitterExt();
			h.setRotation(0, 0);
			h.setMotion(0, 10, .33, 360, 140,3);
			h.particleClass = ZParticle;
			h.gravity = 1200;
			h.particleDrag.x = 400;
			h.particleDrag.y = 600;

			h.makeParticles("assets/images/heartparticles.png", 20, 0, true);
			_grpDisplayObjs.add(h);
		}
		
		
		h.z = Floor;
		h.setAll("floor", Floor);
		h.x = X;
		h.y = Y;
		h.start(true,.33,0,0,1);
		h.update();
		
	}
	
	private function playerMovement():Void
	{
		var _pressingUp:Bool = false;
		var _pressingDown:Bool = false;
		var _pressingLeft:Bool = false;
		var _pressingRight:Bool = false;
		
		#if !FLX_NO_KEYBOARD
		_pressingUp = FlxG.keys.anyPressed(["W", "UP"]);
		_pressingDown = FlxG.keys.anyPressed(["S", "DOWN"]);
		_pressingLeft = FlxG.keys.anyPressed(["A", "LEFT"]);
		_pressingRight = FlxG.keys.anyPressed(["D", "RIGHT"]);
		#end
		#if !FLX_NO_GAMEPAD
		// do some gamepad stuffs?
		#end
		
		if (_pressingDown && _pressingUp)
			_pressingDown = _pressingUp = false;
		if (_pressingLeft && _pressingRight)
			_pressingLeft = _pressingRight = false;
			
		var mA:Float = -400;
		if (_pressingUp)
		{
			if (_pressingLeft)
				mA = -135;
			else if (_pressingRight)
				mA = -45;
			else 
				mA = -90;
		}
		else if (_pressingDown)
		{
			if (_pressingLeft)
				mA = 135;
			else if (_pressingRight)
				mA = 45;
			else
				mA = 90;
		}
		else if (_pressingLeft)
			mA = -180;
		else if (_pressingRight)
			mA = 0;
		
		if (mA != -400)
		{
			var v:FlxPoint = FlxAngle.rotatePoint(Math.max(SPEED * Math.min(((_energy / 100) * 2), 1), 100), 0, 0, 0, mA);
			player.velocity.x = v.x;
			player.velocity.y = v.y;
			
			if (player.velocity.x > 0 && Math.abs(player.velocity.x) > Math.abs(player.velocity.y))
				player.facing = FlxObject.RIGHT;
			else if (player.velocity.x < 0 && Math.abs(player.velocity.x) > Math.abs(player.velocity.y))
				player.facing = FlxObject.LEFT;
			else if (player.velocity.y > 0)
				player.facing = FlxObject.DOWN;
			else if (player.velocity.y < 0)
				player.facing = FlxObject.UP;
		}
		
		if (!_pressingDown && !_pressingUp)
			if (Math.abs(player.velocity.y) > 1)
				player.velocity.y *= FRICTION;
		if (!_pressingLeft && !_pressingRight)
			if (Math.abs(player.velocity.x) > 1)
				player.velocity.x *= FRICTION;
			
		
		
	}
	
}