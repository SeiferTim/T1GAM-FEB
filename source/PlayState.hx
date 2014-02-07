package;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.addons.text.FlxBitmapFont;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxAngle;
import flixel.util.FlxGradient;
import flixel.util.FlxPoint;
import flixel.util.FlxSort;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;

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
	private var _grpPickups:FlxGroup;
	
	private var _grass:FlxSprite;
	private var _map:FlxOgmoLoader;
	private var _walls:FlxTilemap;
	
	private var _emtHeartBurst:ZEmitterExt;
	private var _energy:Float = 100;
	private var _barEnergy:FlxBar;
	private var _twnBar:FlxTween;
	private var _barFadingOut:Bool = false;
	private var _barFadingIn:Bool = false;
	private var _idleTimer:Float = 0;
	
	private var _meatBagCounter:FlxBitmapFont;
	private var _meatBagCounterIcon:MeatBag;
	private var _countBack:FlxSprite;
	
	private var _gameTimer:Float = 0;
	private var _txtGameTimer:FlxBitmapFont;
	private var _sprGameTimerBack:FlxSprite;
	
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
		_grpPickups = new FlxGroup(20);
		
		player = new DisplaySprite(0, 0);
		player.makeGraphic(32, 32, 0xff1F64B1);
		player.width = 16;
		player.height = 24;
		player.offset.x = 8;
		player.offset.y = 8;
		
		_grass = FlxGridOverlay.create(64, 64, FlxG.width, FlxG.height,false, true, 0xff77C450, 0xff2A9D0C);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		_grpMap.add(_grass);
		
		player.x = (FlxG.width - player.width) / 2;
		player.y = (FlxG.height - player.height) / 2;
		player.forceComplexRender = true;
		
		_map = new FlxOgmoLoader("assets/data/level-0001.oel");
		_walls = _map.loadTilemap("assets/images/walls.png", 16, 16, "walls");
		FlxSpriteUtil.screenCenter(_walls, true, true);
		//trace(_walls.x + " " + _walls.y);
		_map.loadEntities(loadEntity, "meats");
		
		_grpMap.add(_walls);
		
		add(_grpMap);
		add(_grpDisplayObjs);
		_grpDisplayObjs.add(player);
		add(_grpFX);
		add(_grpHUD);
		
		_barEnergy = new FlxBar(0, FlxG.height - 24, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * .4), 16, this, "_energy", 0, 100, true);
		_barEnergy.createFilledBar(0xff006666, 0xff00ffff, true, 0xff003333);
		FlxSpriteUtil.screenCenter(_barEnergy, true, false);
		_grpHUD.add(_barEnergy);
		
		_meatBagCounter = new FlxBitmapFont("assets/images/huge_numbers.png", 32, 32, " 0123456789:.", 13, 0, 0, 0, 0);
		_meatBagCounter.setText(" 0", false, 0, 0, FlxBitmapFont.ALIGN_RIGHT);
		_meatBagCounter.scrollFactor.x = _meatBagCounter.scrollFactor.y = 0;
		_meatBagCounter.x = FlxG.width - 104;
		_meatBagCounter.y = FlxG.height - 40;
		_meatBagCounter.alpha = .8;
		
		_meatBagCounterIcon = new MeatBag(FlxG.width - 28, _meatBagCounter.y + 12);
		_meatBagCounterIcon.isReal = false;
		_meatBagCounterIcon.facing = FlxObject.LEFT;
		_meatBagCounterIcon.scrollFactor.x = _meatBagCounterIcon.scrollFactor.y = 0;
		_meatBagCounterIcon.alpha = .8;
		
		_countBack = FlxGradient.createGradientFlxSprite(120, 16, [0x00006666, 0xcc006666, 0xcc006666, 0xcc006666], 1, 0, true);
		_countBack.x = FlxG.width - 120;
		_countBack.y = FlxG.height - 24;
		_countBack.scrollFactor.x = _countBack.scrollFactor.y = 0;
		_countBack.alpha = .8;
		
		_gameTimer = 60;
		_txtGameTimer = new FlxBitmapFont("assets/images/huge_numbers.png", 32, 32, " 0123456789:.", 13, 0, 0, 0, 0);
		_txtGameTimer.setText("60.0", false, 0, 0, FlxBitmapFont.ALIGN_LEFT);
		_txtGameTimer.scrollFactor.x = _txtGameTimer.scrollFactor.y = 0;
		_txtGameTimer.x = 40;
		_txtGameTimer.y = FlxG.height - 40;
		_txtGameTimer.alpha = .8;
		
		_sprGameTimerBack = FlxGradient.createGradientFlxSprite(120, 16, [0x00006666, 0xcc006666, 0xcc006666, 0xcc006666], 1, 0, true);
		_sprGameTimerBack.x = 0;
		_sprGameTimerBack.y = FlxG.height -24;
		_sprGameTimerBack.scrollFactor.x = _sprGameTimerBack.scrollFactor.y = 0;
		_sprGameTimerBack.alpha  = .8;
		
		_grpHUD.add(_countBack);
		_grpHUD.add(_meatBagCounter);
		_grpHUD.add(_meatBagCounterIcon);
		
		_grpHUD.add(_sprGameTimerBack);
		_grpHUD.add(_txtGameTimer);
		
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, true, fadeInDone);
		
		FlxG.watch.add(this, "_idleTimer");
		FlxG.watch.add(player.velocity, "x");
		FlxG.watch.add(player.velocity, "y");
		
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
		FlxG.overlap(player, _grpPickups, pickupEnergy);
		
		if (Math.abs(player.velocity.x) < 10)
			player.velocity.x = 0;
		
		if (Math.abs(player.velocity.y) < 10)
			player.velocity.y = 0;
			
		if (player.velocity.x != 0 || player.velocity.y != 0)
		{
			_idleTimer = 1;
		}
		else
		{
			if (_idleTimer > 0)
			{
				_idleTimer -= FlxG.elapsed;
			}
		}
				
		if (_idleTimer > 0)
		{
			_energy -= FlxG.elapsed * 9;
		}
		else
		{
			_energy += FlxG.elapsed * 3;
		}
		
		if (_energy < 0)
			_energy = 0;
		else if (_energy > 100)
			_energy = 100;
		
		if (player.y + player.height > FlxG.height - 48)
		{
			_countBack.alpha = _barEnergy.alpha = _meatBagCounter.alpha = _meatBagCounterIcon.alpha = .33;
		}
		else
		{
			
			_countBack.alpha = _meatBagCounter.alpha = _meatBagCounterIcon.alpha =  _barEnergy.alpha = .8;
		}
		
		_grpDisplayObjs.sort(zSort,FlxSort.ASCENDING);
		
		var living:Int = getLivingBags();
		_meatBagCounter.text = StringTools.lpad(Std.string(living)," ",2);
		
		if (_gameTimer>0)
			_gameTimer -= FlxG.elapsed;
		else
			_gameTimer = 0;
		
		var sec:Int = Std.int(_gameTimer);
		var ms:String = Std.string(_gameTimer - sec).substr(2,1);
		
			
		_txtGameTimer.text = StringTools.lpad(Std.string(sec), "0", 2) + "." + ms;
	}	
	
	private function zSort(Order:Int, A:FlxBasic, B:FlxBasic):Int
	{
		var zA:Float = Type.getClassName(Type.getClass(A)) == "ZEmitterExt" ? cast(A, ZEmitterExt).z : cast(A, DisplaySprite).z;
		var zB:Float = Type.getClassName(Type.getClass(B)) == "ZEmitterExt" ? cast(B, ZEmitterExt).z : cast(B, DisplaySprite).z;
		var result:Int = 0;
		if (zA < zB)
			result = Order;
		else if (zA > zB)
			result = -Order;
		return result;
	}
	
	private function pickupEnergy(P:FlxBasic, E:FlxBasic):Void
	{
		if (P.alive && P.exists && E.alive && E.exists && !cast(E, EnergyPickup).dying)
		{
			cast(E, EnergyPickup).startKilling();
			_energy += 10;
		}
	}
	
	private function getLivingBags():Int
	{
		var count:Int = 0;
		for (o in _grpMeat.members)
		{
			if (!cast(o, MeatBag).dying && o.alive && o.exists && o.visible)
				count++;
		}
		return count;
	}
	
	/*
	private function fadeOutEnergyBar():Void
	{
		if (_barFadingOut || _barEnergy.alpha <= .4)
			return;
		_barFadingOut = true;
		if (_barFadingIn)
			_twnBar.cancel();
		_barFadingIn = false;
		_twnBar = FlxTween.multiVar(_barEnergy, { alpha:.4 }, .2, { type:FlxTween.ONESHOT, complete:finishBarFadeOut } );
		
	}
	
	private function finishBarFadeOut(T:FlxTween):Void
	{
		_barFadingOut = false;
	}
	
	private function fadeInEnergyBar():Void
	{
		if (_barFadingIn || _barEnergy.alpha >= 1)
			return;
		_barFadingIn = true;
		if (_barFadingOut)
			_twnBar.cancel();
		_barFadingOut = false;
		_twnBar = FlxTween.multiVar(_barEnergy, { alpha:1 }, .2, { type:FlxTween.ONESHOT, complete:finishBarFadeIn } );
	
	}
	
	private function finishBarFadeIn(T:FlxTween):Void
	{
		_barFadingIn = false;
	}*/
	
	public function heartBurst(X:Float, Y:Float, Floor:Float, MeatBagCenter:FlxPoint):Void
	{
		var h:ZEmitterExt=null;
		
		for (o in _grpDisplayObjs.members)
		{
			if (Type.getClassName(Type.getClass(o)) == "ZEmitterExt")
			{
				if (cast(o, ZEmitterExt).countLiving() == 0)
				{
					h = cast(o, ZEmitterExt);
					//trace("revival!");
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
			h.gravity = 600;
			h.particleDrag.x = 400;
			h.particleDrag.y = 600;

			h.makeParticles("assets/images/heartparticles.png", 100, 0, true);
			_grpDisplayObjs.add(h);
		}
		
		
		h.z = Floor;
		h.setAll("floor", Floor);
		h.x = X;
		h.y = Y;
		h.start(true,.33,0,0,1);
		h.update();
		
		_grpDisplayObjs.add(_grpPickups.recycle(EnergyPickup, [MeatBagCenter.x - 8, MeatBagCenter.y- 10]));
		
		
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
			var v:FlxPoint = FlxAngle.rotatePoint(Math.max(SPEED * Math.min(((_energy / 100) * 2), 1), 180), 0, 0, 0, mA);
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