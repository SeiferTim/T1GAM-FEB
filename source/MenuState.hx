package;

import flash.system.System;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.text.FlxBitmapFont;
import flixel.addons.ui.FlxUIButton;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.tile.FlxTileblock;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _btnPlay:GameButton;
	private var _btnOptions:GameButton;
	private var _btnCredits:GameButton;
	private var _btnHowTo:GameButton;
	private var _leaving:Bool = false;
	private var _loading:Bool = true;
	private var _tmr:FlxTimer;
	
	private var _grpStampede:FlxGroup;
	
	private var _txtSubtitle:NewGameFont;
	private var _twnSub:FlxTween;
	private var _twnDelay:FlxTimer;
	private var _twnBack:FlxTimer;
	private var _titleBack:TitleBackBar;
	
	#if (desktop && !FLX_NO_MOUSE)
	//private var _sprExit:FlxSprite;
	private var _btnExit:FlxUIButton;
	#end
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		
		
		FlxG.autoPause = false;
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		var _grass:FlxSprite = FlxGridOverlay.create(64, 48, FlxG.width + 64, FlxG.height+64, false, true, 0xff77C450, 0xff67b440);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_grass);
		add(_grass);
		
		
		var _random:FlxTileblock = new FlxTileblock(0, 0, FlxG.width+64, FlxG.height+64);
		_random.loadTiles("assets/images/random_junk.png", 32, 32, 64);
		_random.scrollFactor.x = _random.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_random);
		add(_random);
		
		_grpStampede = new FlxGroup(60);
		add(_grpStampede);
		
		_titleBack = new TitleBackBar();
		add(_titleBack);

		var s:FlxSprite = new FlxSprite(0, 0);
		s.makeGraphic(FlxG.width, FlxG.height, 0xff77C450);
		add(s);
		
		var m:MeatBag;
		for (i in 0...4)
		{
			m = new MeatBag(FlxRandom.intRanged(FlxG.width,FlxG.width+16), FlxRandom.intRanged(-16,FlxG.height+16));
			m.facing = FlxObject.LEFT;
			m.velocity.x = -300 - FlxRandom.intRanged(0, 200);
			m.velocity.y = FlxRandom.intRanged( -50, 50);
			m.isReal = false;
			_grpStampede.add(m);
		}
		
		
		
		_tmr = FlxTimer.start(FlxG.width/30000, spawnMeatBag, 0);

		_btnPlay = new GameButton(0, 0, "Play", goLevelSelect, GameButton.STYLE_LARGE);
		_btnPlay.x = (FlxG.width -_btnPlay.width) / 2;
		_btnPlay.y = FlxG.height - _btnPlay.height - 64;
		add(_btnPlay);
		
		
		_btnOptions = new GameButton(0, 0, "Options", goOptions, GameButton.STYLE_SMALL,120);
		_btnOptions.x = (FlxG.width / 2) - (_btnOptions.width) - 32;
		_btnOptions.y =FlxG.height - _btnOptions.height - 16;
		add(_btnOptions);
		
		_btnCredits = new GameButton(0, 0, "Credits", goCredits, GameButton.STYLE_SMALL,120);
		_btnCredits.x = (FlxG.width / 2) +   32;
		_btnCredits.y = FlxG.height - _btnCredits.height - 16;
		add(_btnCredits);
		
		//_btnHowTo = new GameButton(0, 0, "How To Play", goHowTo, GameButton.STYLE_SMALL,120);
		//_btnHowTo.x = (FlxG.width / 2) - (_btnOptions.width/2) - _btnHowTo.width - 32;
		//_btnHowTo.y = FlxG.height - _btnHowTo.height - 16;
		//add(_btnHowTo);
		
		var titleFloor:Float  = (FlxG.height / 2) - 70;
		add(new TitleLetter((FlxG.width/2)-50, -150, TitleLetter.LETTER_T, titleFloor,.4));
		add(new TitleLetter((FlxG.width/2)-80, -150, TitleLetter.LETTER_A, titleFloor,.3));
		add(new TitleLetter((FlxG.width/2)-110, -150, TitleLetter.LETTER_E, titleFloor,.2));
		add(new TitleLetter((FlxG.width/2)-140, -150, TitleLetter.LETTER_M, titleFloor,.1));
		add(new TitleLetter((FlxG.width/2)+90, -150, TitleLetter.LETTER_S, titleFloor,.9));
		add(new TitleLetter((FlxG.width/2)+60, -150, TitleLetter.LETTER_G, titleFloor,.8));
		add(new TitleLetter((FlxG.width/2)+30, -150, TitleLetter.LETTER_A, titleFloor,.7));
		add(new TitleLetter((FlxG.width/2)+0, -150, TitleLetter.LETTER_B, titleFloor,.6));
		
		_txtSubtitle = new NewGameFont(0,0,"- The Video Game -", NewGameFont.STYLE_LARGE,NewGameFont.COLOR_BLUE);//new FlxBitmapFont("assets/images/small_white_font.png", 16,16, FlxBitmapFont.TEXT_SET1, 96, 0, 0, 16, 0);
		//_txtSubtitle.setText("- The Video Game -", false, 0, 0, FlxBitmapFont.ALIGN_CENTER, true);
		_txtSubtitle.y = titleFloor + 75;
		FlxSpriteUtil.screenCenter(_txtSubtitle, true, false);
		_txtSubtitle.alpha = 0;
		add(_txtSubtitle);
		_twnDelay = FlxTimer.start(1.4, doneWaitSubtitle);
		_twnBack = FlxTimer.start(.8, doneWaitStart);
		
		#if (desktop && !FLX_NO_MOUSE)
		//_sprExit = new FlxSprite(FlxG.width - 32, 16).loadGraphic("assets/images/exit.png", true, false, 16, 16);
		//_sprExit.animation.add("off", [0]);
		//_sprExit.animation.add("on", [1]);
		//_sprExit.animation.play("off");
		//_sprExit.visible = true;
		//add(_sprExit);
		_btnExit = new FlxUIButton(FlxG.width - 48, 16, "", exitGame);
		_btnExit.loadGraphicsUpOverDown("assets/images/exit.png");
		add(_btnExit);
		#end
		
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, true, fadeInDone);
		
		super.create();
	}
	
	private function goCredits():Void
	{
		if (_leaving || _loading )
			return;
		_leaving = true;		
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, false, goCreditsDone);
	}
	
	private function doneWaitStart(T:FlxTimer):Void
	{
		_titleBack.start();
	}
	
	private function goLevelSelect():Void
	{
		if (_leaving || _loading )
			return;
		_leaving = true;		
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, false, goLevelSelectDone);
	}
	
	
	private function doneWaitSubtitle(T:FlxTimer):Void
	{
		
		_twnSub = FlxTween.singleVar(_txtSubtitle, "alpha", 1, .66, { type:FlxTween.ONESHOT, ease:FlxEase.quintOut } );
	}
	
	private function fadeInDone():Void
	{
		_loading = false;
		
	}
	
	private function goOptions():Void
	{
		if (_leaving || _loading)
			return;
		_leaving = true;
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, goOptionsDone);
	}
	
	private function goOptionsDone():Void
	{
		FlxG.switchState(new OptionsState());
	}

	private function goCreditsDone():Void
	{
		FlxG.switchState(new CreditsState());
	}
	
	
	
	private function goLevelSelectDone():Void
	{
		
		FlxG.switchState(new LevelsState());
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	#if (desktop && !FLX_NO_MOUSE)
	private function exitGame():Void
	{
		if (_leaving || _loading)
			return;
		_leaving = true;
		FlxG.mouse.reset();
		System.exit(0);
	}
	#end
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		_grpStampede.sort(zSort);
		super.update();
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
	
	private function spawnMeatBag(T:FlxTimer):Void
	{
		var m:MeatBag;
		m = cast _grpStampede.recycle(MeatBag, [-100,0]);
		if (m != null)
		{
			if ( m.x + m.width < 0)
			{
				m.x = FlxG.width + 16;
				m.y = FlxRandom.intRanged( -16, FlxG.height + 16);		
				m.facing = FlxObject.LEFT;
				m.velocity.x = -300 - FlxRandom.intRanged(0, 200);
				m.velocity.y = FlxRandom.intRanged( -50, 50);
				m.isReal = false;
			}
		}
	}
}