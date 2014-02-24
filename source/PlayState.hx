package;

import flash.geom.Rectangle;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.addons.text.FlxBitmapFont;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.touch.FlxTouch;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
import flixel.util.FlxSort;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private static inline var SPEED:Int = 600;
	private static inline var FRICTION:Float = .8;
	public static inline var GAMETIME:Float = 28;
	
	private var _loading:Bool = true;
	private var _unloading:Bool = false;
	
	public var player:DisplaySprite;
	public var grpMeat(default, null):FlxGroup;
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
	
	private var _barTime:FlxBar;
	private var _scoreTimer:Float;

	private var _meatBagCounter:GameFont;
	private var _meatBagCounterIcon:MeatBag;
	private var _countBack:FlxSprite;
	
	private var _gameTimer:Float = 0;
	
	private var _score:Int = 0;
	private var _txtScore:GameFont;
	private var _sprScore:FlxSprite;
	
	private var _pointer:FlxSprite;
	private var _twnPointer:FlxTween;
	private var _moveToTarget:FlxPoint;
	
	private var _txtClock:GameFont;
	
	private var _paused:Bool = false;
	private var _pauseScreen:PauseScreen;
	private var _twnPause:FlxTween;
	
	//private var _realTimer:FlxTimer;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		Reg.playState = this;
		
		_grpDisplayObjs = new FlxGroup();
		
		_grpMap = new FlxGroup();
		grpMeat = new FlxGroup();
		_grpFX = new FlxGroup();
		_grpHUD = new FlxGroup();
		_grpPickups = new FlxGroup(20);
		
		player = new DisplaySprite(0, 0);
		player.makeGraphic(16, 16, 0xff1F64B1);
		player.width = 8;
		player.height = 12;
		player.offset.x = 4;
		player.offset.y = 4;
		
		//_grass = FlxGridOverlay.create(16, 16, (Math.ceil(FlxG.width/16)*16)+8, (Math.ceil(FlxG.height/16)*16)+8,false, true, 0xff77C450, 0xff67b440);
		_grass = new FlxSprite(0, 0, "assets/images/ground.png");
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_grass);
		_grpMap.add(_grass);
		
		//player.x = (FlxG.width - player.width) / 2;
		//player.y = (FlxG.height - (player.height * 3));
		player.forceComplexRender = true;
		
		_map = new FlxOgmoLoader("assets/data/level-" + StringTools.lpad(Std.string(Reg.level),"0",4) +  ".oel");
		_walls = _map.loadTilemap("assets/images/walls.png", 8, 8, "walls");
		FlxSpriteUtil.screenCenter(_walls, true, true);
		
		
		_map.loadRectangles(loadMeatZone, "meats");
		
		_map.loadEntities(loadPStart, "playerStart");
		
		
		_grpMap.add(_walls);
		
		add(_grpMap);
		add(_grpDisplayObjs);
		_grpDisplayObjs.add(player);
		add(_grpFX);
		add(_grpHUD);
		
		_barEnergy = new FlxBar(0, FlxG.height - 24, FlxBar.FILL_LEFT_TO_RIGHT, Std.int(FlxG.width * .4), 16, this, "_energy", 0, 100, true);
		_barEnergy.createFilledBar(0xff006666, 0xff00ffff, true, 0xff003333);
		
		FlxSpriteUtil.screenCenter(_barEnergy, true, false);
		_barEnergy.alpha = .8;
		_grpHUD.add(_barEnergy);
		
		if (Reg.mode == Reg.MODE_NORMAL || Reg.mode == Reg.MODE_HUNGER)
		{
			_barTime = new FlxBar(0, 8, FlxBar.FILL_LEFT_TO_RIGHT, FlxG.width - 64, 16, this, "_gameTimer", 0, GAMETIME, true);
			_barTime.createFilledBar(0xff666600, 0xffffff00, true, 0xff333300);
			
			FlxSpriteUtil.screenCenter(_barTime, true, false);
			_barTime.alpha = .8;
			_grpHUD.add(_barTime);
		}
		else if (Reg.mode == Reg.MODE_ENDLESS)
		{
			_txtClock = new GameFont(FlxStringUtil.formatTime(_gameTimer, true), GameFont.STYLE_LG_NUMBERS, FlxBitmapFont.ALIGN_CENTER);//new FlxBitmapFont("assets/images/huge_numbers.png", 32, 32, " .0123456789:", 13, 0, 0, 0, 0);
			//_txtClock.setText(FlxStringUtil.formatTime(_gameTimer, true), false, 0, 0, FlxBitmapFont.ALIGN_CENTER);
			_txtClock.scrollFactor.x = _txtClock.scrollFactor.y = 0;
			_txtClock.y = 16;
			FlxSpriteUtil.screenCenter(_txtClock, true, false);
			_txtClock.alpha = .9;
			_grpHUD.add(_txtClock);
			
		}
		
		_meatBagCounter = new GameFont(" 0", GameFont.STYLE_LG_NUMBERS, FlxBitmapFont.ALIGN_RIGHT);//FlxBitmapFont("assets/images/huge_numbers.png", 32, 32, " .0123456789:", 13, 0, 0, 0, 0);
		//_meatBagCounter.setText(" 0", false, 0, 0, FlxBitmapFont.ALIGN_RIGHT);
		_meatBagCounter.scrollFactor.x = _meatBagCounter.scrollFactor.y = 0;
		_meatBagCounter.x = FlxG.width - 108;
		_meatBagCounter.y = FlxG.height - 48;
		_meatBagCounter.alpha = .9;
		
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
		
		_gameTimer = 0;
		_score = 0;
		_scoreTimer = 1;
		//_realTimer = FlxTimer.start(1, updateGameTime, 0);
		
		_txtScore = new GameFont("0", GameFont.STYLE_LG_NUMBERS);//FlxBitmapFont("assets/images/huge_numbers.png", 32, 32, " .0123456789:", 13, 0, 0, 0, 0);
		//_txtScore.setText("0", false, 0, 0, FlxBitmapFont.ALIGN_LEFT);
		_txtScore.scrollFactor.x = _txtScore.scrollFactor.y = 0;
		_txtScore.x = 16;
		_txtScore.y = FlxG.height - 48;
		_txtScore.alpha = .9;
		
		_sprScore = FlxGradient.createGradientFlxSprite(120, 16, [0x00006666, 0xcc006666, 0xcc006666, 0xcc006666], 1, 180, true);
		_sprScore.x = 0;
		_sprScore.y = FlxG.height -24;
		_sprScore.scrollFactor.x = _sprScore.scrollFactor.y = 0;
		_sprScore.alpha  = .8;
		
		_grpHUD.add(_countBack);
		_grpHUD.add(_meatBagCounter);
		_grpHUD.add(_meatBagCounterIcon);
		
		_grpHUD.add(_sprScore);
		_grpHUD.add(_txtScore);
		
		_pointer = new FlxSprite(0, 0).loadGraphic("assets/images/pointer.png", true, false, 16, 16);
		_pointer.scrollFactor.x = _pointer.scrollFactor.y = 0;
		_pointer.visible = false;
		
		_grpHUD.add(_pointer);
		
		_twnPointer = FlxTween.multiVar(_pointer, { alpha:.6 }, .1, { type:FlxTween.PINGPONG, ease:FlxEase.circInOut } );
		
		_pauseScreen = new PauseScreen();
		_pauseScreen.visible = false;
		_pauseScreen.alpha = 0;
		_grpHUD.add(_pauseScreen);
		
		switch(Reg.mode)
		{
			case Reg.MODE_NORMAL, Reg.MODE_HUNGER:
				FlxG.sound.playMusic("normal", 1, false);
				
			case Reg.MODE_ENDLESS:
				FlxG.sound.playMusic("endless");
		}
		
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, true, fadeInDone);
		
		FlxG.watch.add(this, "_gameTimer");
		
		super.create();
	}
	
	private function updateGameTime(T:FlxTimer):Void
	{
		_gameTimer++;
	}
	
	private function loadMeatZone(R:FlxRect):Void
	{
		var m:MeatBag;
		for (i in 0...Reg.levels[Reg.level].numberOfMBsPer)
		{
			m = new MeatBag(Std.int(FlxRandom.floatRanged(R.x, R.right)), Std.int(FlxRandom.floatRanged(R.y, R.bottom)));
			grpMeat.add(m);
			_grpDisplayObjs.add(m);
		}
	}
	
	
	
	private function loadPStart(EType:String, EXml:Xml):Void
	{
		player.x = Std.parseFloat(EXml.get("x"));
		player.y = Std.parseFloat(EXml.get("y"));
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
		
		
		if (_loading || _unloading)
		{
			//super.update();
			FlxG.camera.update();
			
			return;
		}
		
		var _pressedPause:Bool = false;
		
		#if (!FLX_NO_KEYBOARD)
		
		if (FlxG.keys.anyJustReleased(["P", "ESCAPE"]))
		{
			_pressedPause = true;
		}		
		
		#end
		
		#if (android)
		{
			if (FlxG.android.anyJustReleased(["MENU"]))
			{
				_pressedPause = true;
			}
		}
		#end
		
		if (_paused)
		{
			if (_pauseScreen.clickedResume || _pressedPause)
			{
				// start unpausing
				/*if (_realTimer != null)
				{
					_realTimer.paused = false;
				}*/
				_pauseScreen.clickedResume = false;
				_twnPause = FlxTween.singleVar(_pauseScreen, "alpha", 0, Reg.FADE_DUR, {type:FlxTween.ONESHOT,ease:FlxEase.circOut, complete: donePauseOut } );
			}
			//super.update();
			_pauseScreen.update();
			return;
		}
		else
		{
			
			if (_pressedPause)
			{
				/*if (_realTimer != null)
				{
					_realTimer.paused = true;
				}*/
				startPause();
			}
		}
		
		playerMovement();
		
		super.update();
		
		FlxG.collide(player, _walls);
		//FlxG.collide(grpMeat, grpMeat);
		FlxG.collide(grpMeat, _walls);
		FlxG.overlap(player, _grpPickups, pickupEnergy);

		if (!player.isOnScreen())
		{
			
			if (player.x < -(player.width * 2))
			{
				player.x = -(player.width * 2);
				player.velocity.x = 0;
			}
			else if (player.x > FlxG.width + (player.width * 3))
			{
				player.x = FlxG.width + (player.width * 3);
				player.velocity.x = 0;
			}
			
			if (player.y < -(player.height * 2))
			{
				player.y = -(player.height * 2);
				player.velocity.y = 0;
			}
			else if (player.y > FlxG.height + (player.height * 3))
			{
				player.y = FlxG.height + (player.height * 3);
				player.velocity.y = 0;
			}
			
			var pM:FlxPoint = player.getMidpoint();
			
			
			
			if (pM.x < 0)
			{
				if (pM.y < 0)
				{
					_pointer.x = 2;
					_pointer.y = 2;
					_pointer.animation.frameIndex = 4;
				}
				else if (pM.y >= FlxG.height)
				{
					_pointer.animation.frameIndex = 6;
					_pointer.x = 2;
					_pointer.y = FlxG.height - _pointer.y - 2;
				}
				else
				{
					_pointer.animation.frameIndex = 0;
					_pointer.x = 2;
					_pointer.y = pM.y - (_pointer.height / 2);
				}
			}
			else if (pM.x >= FlxG.width)
			{
				if (pM.y < 0)
				{
					_pointer.animation.frameIndex = 5;
					_pointer.x = FlxG.width - _pointer.width - 2;
					_pointer.y = 2;
				}
				else if (pM.y >= FlxG.height)
				{
					_pointer.animation.frameIndex = 7;
					_pointer.x = FlxG.width - _pointer.width - 2;
					_pointer.y = FlxG.height - _pointer.height - 2;
				}
				else
				{
					_pointer.animation.frameIndex = 1;
					_pointer.x = FlxG.width - _pointer.width - 2;
					_pointer.y = pM.y - (_pointer.height / 2);
				}
			}
			else if (pM.y < 0)
			{
				_pointer.animation.frameIndex = 2;
				_pointer.x = pM.x - (_pointer.width / 2);
				_pointer.y = 2;
			}
			else if (pM.y >= FlxG.height)
			{
				_pointer.animation.frameIndex = 3;
				_pointer.x = pM.x - (_pointer.width / 2);
				_pointer.y = FlxG.height - _pointer.height - 2;
			}
			
			
			_pointer.visible = true;
		}
		else
		{
			_pointer.visible = false;
		}
		
		if (Math.abs(player.velocity.x) < 10)
			player.velocity.x = 0;
		
		if (Math.abs(player.velocity.y) < 10)
			player.velocity.y = 0;
			
		if (player.velocity.x != 0 || player.velocity.y != 0)
		{
			_idleTimer = .25;
			_energy -= FlxG.elapsed * 6;
		}
		else
		{
			if (_idleTimer > 0)
			{
				_idleTimer -= FlxG.elapsed;
			}
		}
		
		if (_idleTimer <= 0)
		{
			_energy += FlxG.elapsed * 3;
		}
		
		if (_energy < 0)
			_energy = 0;
		else if (_energy > 100)
			_energy = 100;
		
		if (player.y  < 48)
		{
			if (Reg.mode == Reg.MODE_NORMAL || Reg.mode == Reg.MODE_HUNGER)
			{
				_barTime.alpha = .3;
			}
			else if (Reg.mode == Reg.MODE_ENDLESS)
			{
				_txtClock.alpha = .4;
			}
		}
		else
		{
			
			if (Reg.mode == Reg.MODE_NORMAL || Reg.mode == Reg.MODE_HUNGER)
			{
				_barTime.alpha = .8;
			}
			else if (Reg.mode == Reg.MODE_ENDLESS)
			{
				_txtClock.alpha = .9;
			}
		}
			
			
		if (player.y + player.height > FlxG.height - 48)
		{
			_sprScore.alpha =  _countBack.alpha = _barEnergy.alpha =  _meatBagCounterIcon.alpha = .3;
			_txtScore.alpha = _meatBagCounter.alpha = .4;
		}
		else
		{
			
			_sprScore.alpha =  _countBack.alpha = _meatBagCounter.alpha =   _barEnergy.alpha = .8;
			_meatBagCounterIcon.alpha = _txtScore.alpha = .9;
		}
		
		_grpDisplayObjs.sort(zSort,FlxSort.ASCENDING);
		
		var living:Int = getLivingBags();
		_meatBagCounter.text = StringTools.lpad(Std.string(living)," ",2);
		
				
		//if (_gameTimer < GAMETIME)
		_gameTimer += FlxG.elapsed;
		
		//else
		//	_gameTimer = GAMETIME;
		
		if (Reg.mode == Reg.MODE_ENDLESS)
		{
			
			_txtClock.text = FlxStringUtil.formatTime(_gameTimer, true);
			FlxSpriteUtil.screenCenter(_txtClock, true, false);
		}
		if (Reg.mode != Reg.MODE_HUNGER)
		{
			_scoreTimer -= FlxG.elapsed;
			if (_scoreTimer <= 0)
			{
				_score += living;
				_scoreTimer += 1;
			}
		}
		
		_txtScore.text = Std.string(_score);
		
		if ((living <= 0 || (_gameTimer >= GAMETIME && (Reg.mode == Reg.MODE_NORMAL || Reg.mode == Reg.MODE_HUNGER))) && !_unloading)
		{
			/*if (_realTimer != null)
			{
				_realTimer.paused = true;
			}*/
			_unloading = true;
			Reg.leftAlive = living;
			Reg.score = _score;
			Reg.gameTime = _gameTimer;
			FlxG.camera.fade(FlxColor.BLACK, .2, false, goGameOver);
		}
	}	
	
	private function startPause():Void
	{
		_paused = true;
		FlxG.sound.music.pause();
		_pauseScreen.visible = true;
		_pauseScreen.active = true;
		_twnPause = FlxTween.singleVar(_pauseScreen, "alpha", 1, Reg.FADE_DUR, {type:FlxTween.ONESHOT,ease:FlxEase.circOut, complete: donePauseIn } );
	}
	
	private function donePauseIn(T:FlxTween):Void
	{
		
	}
	
	private function donePauseOut(T:FlxTween):Void
	{
		_pauseScreen.visible = false;
		_pauseScreen.active = false;
		_paused = false;
		FlxG.sound.music.resume();
	}
	
	private function goGameOver():Void
	{
		FlxG.sound.playMusic("title");
		FlxG.switchState(new GameOverState());
		
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
			FlxG.sound.play("energy-get");
			_energy += 50;
		}
	}
	
	private function getLivingBags():Int
	{
		var count:Int = 0;
		for (o in grpMeat.members)
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
	
	
	
	public function particleBurst(X:Float, Y:Float, Floor:Float, MeatBagCenter:FlxPoint, Style:Int = 0):Void
	{
		var h:ZEmitterExt=null;
		
		for (o in _grpDisplayObjs.members)
		{
			if (Type.getClassName(Type.getClass(o)) == "ZEmitterExt")
			{
				if (cast(o, ZEmitterExt).style == Style)
				{
					if (cast(o, ZEmitterExt).countLiving() == 0)
					{
						h = cast(o, ZEmitterExt);
						
						break;
					}
				}
			}
		}
		
		if (h == null)
		{
			
			h = new ZEmitterExt();
			h.setRotation(0, 0);
			h.particleClass = ZParticle;
			
			h.style = Style;
			
			if (Style == ZEmitterExt.STYLE_BLOOD)
			{
				h.setMotion(0, 10, .33, 360, 140,3);
				h.gravity = 600;
				h.particleDrag.x = 400;
				h.particleDrag.y = 600;
				h.makeParticles("assets/images/heartparticles.png", 100, 0, true);
			}
			else if (Style == ZEmitterExt.STYLE_CLOUD)
			{
				h.setMotion(0, 20, .66, 360, 100, .88);
				h.gravity = 0;
				h.particleDrag.x = 80;
				h.particleDrag.y = 80;
				h.makeParticles("assets/images/cloudparticles.png", 60, 0, true);
			}
			
			_grpDisplayObjs.add(h);
		}
		
		if (Style == ZEmitterExt.STYLE_CLOUD)
			Floor += 20;
		if (X < 1) 
			X = 1;
		else if (X > FlxG.width)
			X = FlxG.width;
		if (Y < 2) 
		{
			Y = 2;
		//	Floor = 2;
		}
		else if (Y > FlxG.height)
			Y = FlxG.height;
		
		h.z = Floor;
		h.setAll("floor", Floor);
		
		h.x = X;
		h.y = Y;
		
		if (Style == ZEmitterExt.STYLE_BLOOD)
			h.start(true, .33, 0, 0, 1);
		else if (Style == ZEmitterExt.STYLE_CLOUD)
			h.start(true, .66, 0, 0, .88);

		h.update();
		
		if (Style == ZEmitterExt.STYLE_BLOOD)
		{
			if (Reg.mode == Reg.MODE_HUNGER)
			{
				_score += 50;
			}
			_grpDisplayObjs.add(_grpPickups.recycle(EnergyPickup, [MeatBagCenter.x - 8, MeatBagCenter.y- 10]));
		}
		
		
	}
	
	private function playerMovement():Void
	{
		
		#if (!FLX_NO_KEYBOARD || !FLX_NO_GAMEPAD) // only do this section if there is a keyboard or gamepad...
		
		
		
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
			if (_moveToTarget != null)
			{
				_moveToTarget.destroy();
				_moveToTarget = null;
			}
			var v:FlxPoint = FlxAngle.rotatePoint(SPEED * Math.min(.5 + ((_energy/75)/2) ,1), 0, 0, 0, mA);
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
			
		#end
		#if (!FLX_NO_MOUSE || !FLX_NO_TOUCH)
		#if !FLX_NO_MOUSE
			if (FlxG.mouse.pressed)
			{
				if (_moveToTarget != null)
				{
					_moveToTarget.destroy();
					_moveToTarget = null;
				}
				_moveToTarget = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
				
			}
			if (FlxG.mouse.justPressed)
			{
				FlxG.sound.play("mouse-down");
			}
			else if (FlxG.mouse.justReleased)
			{
				FlxG.sound.play("mouse-up");
			}
		#end
		#if !FLX_NO_TOUCH
			
				var touch:FlxTouch = FlxG.touches.getFirst();//  touches[touches.length - 1];
				if (touch != null)
				{
					if (_moveToTarget != null)
					{
						_moveToTarget.destroy();
						_moveToTarget = null;
					}
					_moveToTarget = new FlxPoint(touch.x, touch.y);
					if (touch.justPressed)
					{
						FlxG.sound.play("mouse-down");
					}
					else if (touch.justReleased)
					{
						FlxG.sound.play("mouse-up");
					}
				}
				
			
		#end
		if (_moveToTarget != null)
		{
			
			if (FlxMath.getDistance(player.getMidpoint(), _moveToTarget) < 10)
			{
				_moveToTarget.destroy();
				_moveToTarget = null;
				player.velocity.x = 0;
				player.velocity.y = 0;
			}
			else
			{
				var pA:Float = FlxAngle.getAngle(player.getMidpoint(),_moveToTarget)-90;
				
				var v:FlxPoint = FlxAngle.rotatePoint(SPEED * Math.min(.5 + ((_energy/75)/2) ,1), 0, 0, 0, pA);
				player.velocity.x = v.x;
				player.velocity.y = v.y;
			}
		}
		#end
		
		
	}
	
}