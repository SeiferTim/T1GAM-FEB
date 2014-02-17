package ;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxSpriteAniRot;
import flixel.addons.text.FlxBitmapFont;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.debug.FlxDebugger.ButtonAlignment;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class LevelsState extends FlxState
{

	private var _loading:Bool = true;
	private var _buttons:Array<FlxUIButton>;
	
	private var _btnModeNormal:FlxUIButton;
	private var _btnModeEndless:FlxUIButton;
	private var _locks:Array<FlxSprite>;
	private var _checks:Array<FlxSprite>;
	private var _txtMode:FlxBitmapFont;
	private var _txtLevel:FlxBitmapFont;
	private var _btnMenu:FlxButton;
	
	override public function create() 
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
		
		add(new FlxSprite(4, 4).makeGraphic(FlxG.width - 8, FlxG.height - 8, 0x99000000));
		
		_txtMode = new GameFont("Game Mode", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);//new FlxBitmapFont("assets/images/small_white_font.png", 16, 16, FlxBitmapFont.TEXT_SET1, 96, 0, 0, 16, 0);
		_txtMode.scrollFactor.x = _txtMode.scrollFactor.y = 0;
		_txtMode.y = 16;
		FlxSpriteUtil.screenCenter(_txtMode, true, false);
		add(_txtMode);
		
		_btnModeNormal = new FlxUIButton((FlxG.width / 2) - 88, 40, "Normal Mode", changeMode.bind(Reg.MODE_NORMAL));
		_btnModeEndless = new FlxUIButton((FlxG.width / 2) + 8, 40, "Endless Mode", changeMode.bind(Reg.MODE_ENDLESS));
		_btnModeEndless.broadcastToFlxUI = false;
		_btnModeNormal.status = FlxButton.PRESSED;
		_btnModeNormal.skipButtonUpdate = true;
		_btnModeNormal.broadcastToFlxUI = false;
		add(_btnModeNormal);
		add(_btnModeEndless);
		
		_txtLevel = new GameFont("Select Level", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
		_txtLevel.scrollFactor.x = _txtLevel.scrollFactor.y = 0;
		_txtLevel.y = 80;
		FlxSpriteUtil.screenCenter(_txtLevel, true, false);
		add(_txtLevel);
		
		_buttons = new Array<FlxUIButton>();
		var b:FlxUIButton;
		var buttonAndGapWidth:Float = 80 + 16;
		var buttonAndGapHeight:Float = 20 + 16;
		var screenWidth:Float = Math.floor((FlxG.width - 64) / (buttonAndGapWidth));
		var startX:Float = (FlxG.width/2) -  (((screenWidth * buttonAndGapWidth)-16) / 2);
		_locks = new Array<FlxSprite>();		
		_checks = new Array<FlxSprite>();		
		
		for (l in Reg.levels)
		{
			var bX:Float = startX + (Math.floor(l.number % screenWidth) * buttonAndGapWidth);
			var bY:Float = 104 + (Math.floor(l.number / screenWidth) * buttonAndGapHeight);

			b = new FlxUIButton(bX, bY, Std.string(l.number + 1), levelButtonClick.bind(l.number));
			b.broadcastToFlxUI = false;
			add(b);
			_buttons.push(b);
			
			_locks[l.number] = new FlxSprite(b.x - 8 + (b.width/2) , b.y +  10, "assets/images/lock.png");
			add(_locks[l.number]);
			_locks[l.number].visible = false;
			_checks[l.number] = new FlxSprite(b.x + 4 , b.y + (b.height/2) - 8, "assets/images/check.png");
			add(_checks[l.number]);
			_checks[l.number].visible = false;
		}
		
		setButtons();
		
		_btnMenu = new FlxButton(0, 0, "Main Menu", clickMainMenu);
		_btnMenu.x = FlxG.width - _btnMenu.width - 16;
		_btnMenu.y = FlxG.height - _btnMenu.height - 16;
		add(_btnMenu);	
		
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, true, doneFadeIn);
		
		super.create();
	}
	
	private function setButtons():Void
	{
		var _lastCleared:Bool = true;
		var _isAvailable:Bool = false;
		for (i in 0...Reg.levels.length)
		{
			if (Reg.mode == Reg.MODE_NORMAL && _lastCleared)
			{
				_isAvailable = true;
			}
			else if (Reg.mode == Reg.MODE_ENDLESS && Reg.levels[i].bestScores[0] > 0)
			{
				_isAvailable = true;
			}
			else
				_isAvailable = false;
			
			if (_isAvailable)
			{
				_buttons[i].status = FlxButton.NORMAL;
				_buttons[i].skipButtonUpdate = false;
				_locks[i].visible = false;
			}
			else
			{
				_buttons[i].status = FlxButton.PRESSED;
				_buttons[i].skipButtonUpdate = true;
				_locks[i].visible = true;
				
			}
			
			if (Reg.levels[i].bestScores[0] > 0)
			{
				_lastCleared = true;
			}
			else
			{
				_lastCleared = false;
			}
			if (Reg.mode == Reg.MODE_NORMAL && _lastCleared)
			{
				_checks[i].visible = true;
			}
			else
			{
				_checks[i].visible = false;
			}
		}

	}
	
	private function changeMode(Mode:Int):Void
	{
		if (_loading)
			return;
		switch(Mode)
		{
			case Reg.MODE_NORMAL:
				_btnModeNormal.status = FlxButton.PRESSED;
				_btnModeEndless.status = FlxButton.NORMAL;
				_btnModeNormal.skipButtonUpdate = true;
				_btnModeEndless.skipButtonUpdate = false;
				Reg.mode = Reg.MODE_NORMAL;
				
			case Reg.MODE_ENDLESS:
				_btnModeEndless.status = FlxButton.PRESSED;
				_btnModeNormal.status = FlxButton.NORMAL;
				_btnModeEndless.skipButtonUpdate = true;
				_btnModeNormal.skipButtonUpdate = false;
				Reg.mode = Reg.MODE_ENDLESS;
				
		}
		setButtons();
	}
	
	private function doneFadeIn():Void
	{
		_loading = false;
	}
	
	private function levelButtonClick(Number:Int):Void
	{
		if (_loading || _buttons[Number].skipButtonUpdate)
			return;
		Reg.level = Number;
		_loading = true;
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, doneFadeOut);
		
		
	}
	
	private function clickMainMenu():Void
	{
		if (_loading)
			return;
		_loading = true;
		FlxG.camera.fade(FlxColor.BLACK, Reg.FADE_DUR, false, doneMainMenu);
	}
	
	private function doneMainMenu():Void
	{
		FlxG.switchState(new MenuState());
	}
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new PlayState());
	}
	
}