package ;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxSpriteAniRot;
import flixel.addons.text.FlxBitmapFont;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.debug.FlxDebugger.ButtonAlignment;
import flixel.tile.FlxTileblock;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class LevelsState extends FlxState
{

	private var _loading:Bool = true;
	private var _buttons:Array<GameButton>;
	
	private var _btnModeNormal:GameButton;
	private var _btnModeEndless:GameButton;
	private var _btnModeHunger:GameButton;
	private var _locks:Array<FlxSprite>;
	private var _checks:Array<FlxSprite>;
	private var _txtMode:FlxBitmapFont;
	private var _txtLevel:FlxBitmapFont;
	private var _btnMenu:GameButton;
	private var _selected:FlxSprite;
	private var _scores:Array<GameFont>;
	private var _txtGoal:GameFont;
	
	override public function create() 
	{
		
		FlxG.autoPause = false;
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		var _grass:FlxSprite =  FlxGridOverlay.create(64, 64, FlxG.width + 64, FlxG.height+64, false, true, 0xff77C450, 0xff67b440);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_grass);
		add(_grass);
		
		var _random:FlxTileblock = new FlxTileblock(0, 0, FlxG.width+64, FlxG.height+64);
		_random.loadTiles("assets/images/random_junk.png", 32, 32, 64);
		_random.scrollFactor.x = _random.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_random);
		add(_random);
		
		add(new FlxSprite(4, 4).makeGraphic(FlxG.width - 8, FlxG.height - 8, 0x99000000));
		
		_txtMode = new GameFont("Choose Game Mode", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);//new FlxBitmapFont("assets/images/small_white_font.png", 16, 16, FlxBitmapFont.TEXT_SET1, 96, 0, 0, 16, 0);
		_txtMode.scrollFactor.x = _txtMode.scrollFactor.y = 0;
		_txtMode.y = 16;
		FlxSpriteUtil.screenCenter(_txtMode, true, false);
		add(_txtMode);
		
		_btnModeNormal = new GameButton((FlxG.width / 2) - (200 * 1.5) - 16, 40, "Normal", changeMode.bind(Reg.MODE_NORMAL),GameButton.STYLE_LARGE,200);
		_btnModeEndless = new GameButton((FlxG.width / 2)-(200/2), 40, "Endless", changeMode.bind(Reg.MODE_ENDLESS),GameButton.STYLE_LARGE,200);
		_btnModeHunger = new GameButton((FlxG.width / 2) + (200/2) + 16, 40, "Hunger", changeMode.bind(Reg.MODE_HUNGER),GameButton.STYLE_LARGE,200);
		
		//_btnModeNormal.status = FlxButton.PRESSED;
		//_btnModeNormal.active = false;
		//_btnModeNormal.skipButtonUpdate = true;
		//_btnModeNormal.update();
		
		add(_btnModeNormal);
		add(_btnModeEndless);
		add(_btnModeHunger);
		
		_selected = new FlxSprite(_btnModeNormal.x + 8, _btnModeNormal.y + (_btnModeNormal.height/2) - 8, "assets/images/selected.png");
		add(_selected);
		
		_txtGoal = new GameFont("Goal: Keep them safe in their pens!", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
		_txtGoal.y = 40 + GameButton.SIZE_LG_H + 8;
		FlxSpriteUtil.screenCenter(_txtGoal, true, false);
		add(_txtGoal);
		
		_txtLevel = new GameFont("Select Level", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
		_txtLevel.scrollFactor.x = _txtLevel.scrollFactor.y = 0;
		_txtLevel.y = 120;
		FlxSpriteUtil.screenCenter(_txtLevel, true, false);
		add(_txtLevel);
		
		_buttons = new Array<GameButton>();
		var b:GameButton;
		var buttonAndGapWidth:Float = GameButton.SIZE_LG_W + 16;
		var buttonAndGapHeight:Float = GameButton.SIZE_LG_H + 32;
		var screenWidth:Float = Math.floor((FlxG.width - 64) / (buttonAndGapWidth));
		var startX:Float = (FlxG.width / 2) -  (((screenWidth * buttonAndGapWidth) - 16) / 2) + 8;
		var txtScore:GameFont;
		_locks = new Array<FlxSprite>();		
		_checks = new Array<FlxSprite>();
		_scores = new Array<GameFont>();
		
		for (l in Reg.levels)
		{
			var bX:Float = startX + (Math.floor(l.number % screenWidth) * buttonAndGapWidth);
			var bY:Float = 152 + (Math.floor(l.number / screenWidth) * buttonAndGapHeight);
			//trace(l.number);
			b = new GameButton(bX, bY, Std.string(l.number + 1), levelButtonClick.bind(l.number),GameButton.STYLE_LARGE);
			b.broadcastToFlxUI = false;
			add(b);
			_buttons.push(b);
			
			txtScore = new GameFont("HI: " + StringTools.lpad((l.bestScores[Reg.mode] > 0 ? Std.string(l.bestScores[Reg.mode]) : "-----")," ",5), GameFont.STYLE_TINY_WHITE);
			txtScore.x = b.x + (b.width/2) - (txtScore.width/2);
			txtScore.y = b.y + b.height+ 8;
			add(txtScore);
			_scores.push(txtScore);
			
			_locks[l.number] = new FlxSprite(b.x + 4 , b.y + (b.height/2) - 8, "assets/images/lock.png");
			add(_locks[l.number]);
			_locks[l.number].visible = false;
			_checks[l.number] = new FlxSprite(b.x + 4 , b.y + (b.height/2) - 8, "assets/images/check.png");
			add(_checks[l.number]);
			_checks[l.number].visible = false;
		}
		
		changeMode(Reg.mode, true);
		//setButtons();
		
		_btnMenu = new GameButton(0, 0, "Main Menu", clickMainMenu, GameButton.STYLE_SMALL,0, true);
		_btnMenu.x = FlxG.width - _btnMenu.width - 16;
		_btnMenu.y = FlxG.height - GameButton.SIZE_SM_H - 16;
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
			else if ((Reg.mode == Reg.MODE_ENDLESS || Reg.mode == Reg.MODE_HUNGER) && Reg.levels[i].bestScores[0] > 0)
			{
				_isAvailable = true;
			}
			else
				_isAvailable = false;
			
			if (_isAvailable)
			{
				_buttons[i].status = FlxButton.NORMAL;
				_buttons[i].active = true;
				_buttons[i].skipButtonUpdate = false;
				_locks[i].visible = false;
			}
			else
			{
				_buttons[i].status = FlxButton.PRESSED;
				_buttons[i].active = false;
				_buttons[i].skipButtonUpdate = true;
				_buttons[i].update();
				_locks[i].visible = true;
				
			}
			
			_scores[i].text = "HI: " + StringTools.lpad((Reg.levels[i].bestScores[Reg.mode] > 0 ? Std.string(Reg.levels[i].bestScores[Reg.mode]) : "-----"), " ", 5);
			
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
	
	private function changeMode(Mode:Int, ?Force:Bool = false):Void
	{
		if (_loading && !Force)
			return;
		switch(Mode)
		{
			case Reg.MODE_NORMAL:
				_btnModeNormal.status = FlxButton.PRESSED;
				_btnModeEndless.status = FlxButton.NORMAL;
				_btnModeHunger.status = FlxButton.NORMAL;
				_btnModeNormal.active = false;
				_btnModeEndless.active = true;
				_btnModeHunger.active = true;
				_btnModeNormal.skipButtonUpdate = true;
				_btnModeEndless.skipButtonUpdate = false;
				_btnModeHunger.skipButtonUpdate = false;
				_selected.x = _btnModeNormal.x + 8;
				_btnModeNormal.update();
				_txtGoal.text = "Goal: Keep them safe in their pens!";
				FlxSpriteUtil.screenCenter(_txtGoal, true, false);
			case Reg.MODE_ENDLESS:
				_btnModeEndless.status = FlxButton.PRESSED;
				_btnModeNormal.status = FlxButton.NORMAL;
				_btnModeHunger.status = FlxButton.NORMAL;
				_btnModeNormal.active = true;
				_btnModeEndless.active = false;
				_btnModeHunger.active = true;
				_btnModeEndless.skipButtonUpdate = true;
				_btnModeNormal.skipButtonUpdate = false;
				_btnModeHunger.skipButtonUpdate = false;
				_selected.x = _btnModeEndless.x + 8;
				_btnModeEndless.update();
				_txtGoal.text = "Goal: Keep them safe in their pens!";
				FlxSpriteUtil.screenCenter(_txtGoal, true, false);
			case Reg.MODE_HUNGER:
				_btnModeEndless.status = FlxButton.NORMAL;
				_btnModeNormal.status = FlxButton.NORMAL;
				_btnModeHunger.status = FlxButton.PRESSED;
				_btnModeNormal.active = true;
				_btnModeEndless.active = true;
				_btnModeHunger.active = false;
				_btnModeEndless.skipButtonUpdate = false;
				_btnModeNormal.skipButtonUpdate = false;
				_btnModeHunger.skipButtonUpdate = true;
				_selected.x = _btnModeHunger.x + 8;
				_btnModeHunger.update();
				_txtGoal.text = "Goal: Kill them all!";
				FlxSpriteUtil.screenCenter(_txtGoal, true, false);
		}
		Reg.mode = Mode;
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