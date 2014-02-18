package;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.text.FlxBitmapFont;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _btnPlay:FlxButton;
	private var _btnEndless:FlxButton;
	private var _btnOptions:FlxButton;
	private var _leaving:Bool = false;
	private var _loading:Bool = true;
	private var _tmr:FlxTimer;
	
	private var _grpStampede:FlxGroup;
	
	private var _txtSubtitle:GameFont;
	private var _twnSub:FlxTween;
	private var _twnDelay:FlxTimer;
	private var _twnBack:FlxTimer;
	private var _titleBack:TitleBackBar;
	
	
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
		
		var _grass:FlxSprite = FlxGridOverlay.create(16, 16, (Math.ceil(FlxG.width/16)*16)+8, (Math.ceil(FlxG.height/16)*16)+8,false, true, 0xff77C450, 0xff67b440);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_grass);
		add(_grass);
		
		_grpStampede = new FlxGroup(60);
		add(_grpStampede);
		
		_titleBack = new TitleBackBar();
		add(_titleBack);

		var m:MeatBag;
		for (i in 0...15)
		{
			m = new MeatBag(FlxRandom.intRanged(-16,FlxG.width+16), FlxRandom.intRanged(-16,FlxG.height+16));
			m.facing = FlxObject.LEFT;
			m.velocity.x = -300 - FlxRandom.intRanged(0, 200);
			m.velocity.y = FlxRandom.intRanged( -50, 50);
			m.isReal = false;
			_grpStampede.add(m);
		}
		
		
		
		_tmr = FlxTimer.start(FlxG.width/30000, SpawnMeatBag, 0);
		
		
		_btnPlay = new FlxButton(0, 0, "Play", goLevelSelect);
		
		_btnPlay.x = (FlxG.width /2) - (_btnPlay.width * 1.5) - 32;
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		
		add(_btnPlay);
		
		
		_btnOptions = new FlxButton(0, 0, "Options", goOptions);
		_btnOptions.x = (FlxG.width / 2) + (_btnOptions.width / 2) + 32;
		_btnOptions.y = _btnPlay.y;
		add(_btnOptions);
		
		var titleFloor:Float  = (FlxG.height / 2) - 70;
		add(new TitleLetter((FlxG.width/2)-195, -150, TitleLetter.LETTER_M, titleFloor,.1));
		add(new TitleLetter((FlxG.width/2)-155, -150, TitleLetter.LETTER_E, titleFloor,.2));
		add(new TitleLetter((FlxG.width/2)-115, -150, TitleLetter.LETTER_A, titleFloor,.3));
		add(new TitleLetter((FlxG.width/2)-75, -150, TitleLetter.LETTER_T, titleFloor,.4));
		add(new TitleLetter((FlxG.width/2)+25, -150, TitleLetter.LETTER_B, titleFloor,.6));
		add(new TitleLetter((FlxG.width/2)+65, -150, TitleLetter.LETTER_A, titleFloor,.7));
		add(new TitleLetter((FlxG.width/2)+105, -150, TitleLetter.LETTER_G, titleFloor,.8));
		add(new TitleLetter((FlxG.width/2)+145, -150, TitleLetter.LETTER_S, titleFloor,.9));
		
		_txtSubtitle = new GameFont("- The Video Game -", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);//new FlxBitmapFont("assets/images/small_white_font.png", 16,16, FlxBitmapFont.TEXT_SET1, 96, 0, 0, 16, 0);
		//_txtSubtitle.setText("- The Video Game -", false, 0, 0, FlxBitmapFont.ALIGN_CENTER, true);
		_txtSubtitle.y = titleFloor + 75;
		FlxSpriteUtil.screenCenter(_txtSubtitle, true, false);
		_txtSubtitle.alpha = 0;
		add(_txtSubtitle);
		_twnDelay = FlxTimer.start(1.4, doneWaitSubtitle);
		_twnBack = FlxTimer.start(.8, doneWaitStart);
		
		FlxG.camera.fade(0xff000000, Reg.FADE_DUR, true, fadeInDone);
		
		super.create();
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
	
	private function SpawnMeatBag(T:FlxTimer):Void
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