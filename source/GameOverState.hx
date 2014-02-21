package ;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.text.FlxBitmapFont;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;

class GameOverState extends FlxState
{
	
	private var _loaded:Bool = false;
	private var _unloading:Bool = false;
	
	private var _won:Bool;
	

	override public function create():Void 
	{
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
		
		
		_won = Reg.gameTime >= PlayState.GAMETIME && Reg.leftAlive > 0;
		
		
		var _txtGo:GameFont;
		
		if ((Reg.mode == Reg.MODE_NORMAL && _won) || Reg.mode == Reg.MODE_HUNGER)
		{
			_txtGo = new GameFont("Complete!", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
		}
		else
		{
			_txtGo = new GameFont("Game Over!", GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
		}
		_txtGo.y = 16;
		FlxSpriteUtil.screenCenter(_txtGo, true, false);
		add(_txtGo);
		
		var _txtScore:GameFont = new GameFont("Score " +  StringTools.lpad("", ".", 30 - ("Score ".length + Std.string(Reg.score).length))  + " " + Reg.score, GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER); // (0, 64, FlxG.width, "Score " +  StringTools.lpad("",".",40 - ("Score ".length + Std.string(Reg.score).length))  + " " + Reg.score);
		_txtScore.y = 64;
		FlxSpriteUtil.screenCenter(_txtScore, true, false);
		add(_txtScore);
		
		var _txtLeft:GameFont;
		var _txtBonus:GameFont;
		var _bonusScore:Int;
		
		switch (Reg.mode)
		{

			case  Reg.MODE_HUNGER:
				
				_txtLeft = new GameFont("Time Left " + StringTools.lpad("", ".", 30 - ("Time ".length + FlxStringUtil.formatTime((PlayState.GAMETIME-Reg.gameTime), true).length)) +  " " + FlxStringUtil.formatTime((PlayState.GAMETIME-Reg.gameTime), true), GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
				_bonusScore = Std.int((PlayState.GAMETIME-Reg.gameTime) * 25);
			case Reg.MODE_ENDLESS:
				_txtLeft = new GameFont("Time " + StringTools.lpad("", ".", 30 - ("Time ".length + FlxStringUtil.formatTime(Reg.gameTime, true).length)) +  " " + FlxStringUtil.formatTime(Reg.gameTime, true), GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
				_bonusScore = Std.int(Reg.gameTime * 10);
			default: 
				_txtLeft = new GameFont("Living " + StringTools.lpad("", ".", 30 - ("Living ".length + Std.string(Reg.leftAlive).length)) +  " " + Reg.leftAlive, GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
				_bonusScore = Reg.leftAlive * 100;
		}
		
		_txtLeft.y = 88;
		
		FlxSpriteUtil.screenCenter(_txtLeft, true, false);
		
		add(_txtLeft);
		
		
		_txtBonus = new GameFont("Bonus " + StringTools.lpad("", ".", 30 - ("Bonus ".length + Std.string(_bonusScore).length)) +  " " + Std.string(_bonusScore), GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
		
		//new FlxText(0, 80, FlxG.width, "Bonus " + StringTools.lpad("", ".", 40 - ("Bonus ".length + Std.string(_bonusScore).length)) +  " " + Std.string(_bonusScore));
		
		//_txtBonus.alignment = "center";
		_txtBonus.y = 112;
		FlxSpriteUtil.screenCenter(_txtBonus, true, false);
		add(_txtBonus);
		
		var totalScore:Int = _bonusScore + Reg.score;
		
		var _txtTotal:GameFont = new GameFont("Total " + StringTools.lpad("", ".", 30 - ("Total ".length + Std.string(totalScore).length)) +  " " + Std.string(totalScore), GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER);
		//new FlxText(0, 88, FlxG.width, "Total " + StringTools.lpad("",".",40 - ("Total ".length + Std.string(totalScore).length)) +  " " + Std.string(totalScore));
		//_txtTotal.alignment = "center";
		_txtTotal.y = 136;
		FlxSpriteUtil.screenCenter(_txtTotal, true, false);
		add(_txtTotal);
		
		
		var _btnContinue = new GameButton(0, 0, "Continue", goContinue,GameButton.STYLE_LARGE);
		
		_btnContinue.y = FlxG.height - _btnContinue.height - 16;
		_btnContinue.x = (FlxG.width / 2) - _btnContinue.width - 16;
		
		add(_btnContinue);
		
		var _btnMainMenu = new GameButton(0, 0, "Main Menu", goMainMenu,GameButton.STYLE_LARGE);
		_btnMainMenu .y = _btnContinue.y;
		_btnMainMenu .x = (FlxG.width / 2) + 16;
		
		add(_btnMainMenu);
		
		
		if (_won || Reg.mode != Reg.MODE_NORMAL)
		{
			
			if (Reg.levels[Reg.level].bestScores[Reg.mode] < totalScore)
			{
				Reg.levels[Reg.level].bestScores[Reg.mode] = totalScore;
				Reg.saveScores();
			}
		}
		
		
		FlxG.camera.fade(FlxColor.BLACK, .2, true, doneFadeIn);
		
		super.create();
	}
	
	private function doneFadeIn():Void
	{
		_loaded = true;
	}
	
	
	private function goMainMenu():Void
	{
		if (!_loaded || _unloading)
			return;
		_unloading = true;
		FlxG.camera.fade(FlxColor.BLACK, .2, false, doneMainMenu);
	}
	
	private function doneMainMenu():Void
	{
		FlxG.switchState(new MenuState());
	}
	
	private function goContinue():Void 
	{
		if (!_loaded || _unloading)
			return;
		_unloading = true;
		FlxG.camera.fade(FlxColor.BLACK, .2, false, doneContinue);
	}
	
	private function doneContinue():Void
	{
		FlxG.switchState(new LevelsState());
	}
	
}