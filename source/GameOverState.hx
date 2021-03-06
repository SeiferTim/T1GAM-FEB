package ;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.text.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTileblock;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;

class GameOverState extends FlxState
{
	
	private var _loaded:Bool = false;
	private var _unloading:Bool = false;
	private var _hiScore:NewGameFont;
	private var _won:Bool;
	

	override public function create():Void 
	{
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		var _grass:FlxSprite =  FlxGridOverlay.create(64, 48, FlxG.width + 64, FlxG.height+64, false, true, 0xff77C450, 0xff67b440);
		_grass.scrollFactor.x = _grass.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_grass);
		add(_grass);
		
		
		var _random:FlxTileblock = new FlxTileblock(0, 0, FlxG.width+64, FlxG.height+64);
		_random.loadTiles("assets/images/random_junk.png", 32, 32, 64);
		_random.scrollFactor.x = _random.scrollFactor.y = 0;
		FlxSpriteUtil.screenCenter(_random);
		add(_random);
		
		add(new FlxSprite(4, 4).makeGraphic(FlxG.width - 8, FlxG.height - 8, 0x99000000));
		
		
		_won = Reg.gameTime >= PlayState.GAMETIME && Reg.leftAlive > 0;
		
		
		var _txtGo:NewGameFont;
		
		if ((Reg.mode == Reg.MODE_NORMAL && _won) || Reg.mode == Reg.MODE_HUNGER)
		{
			_txtGo = new NewGameFont(0,0,"Complete!", NewGameFont.STYLE_LARGE, NewGameFont.COLOR_GREEN);
		}
		else
		{
			_txtGo = new NewGameFont(0,0,"Game Over!", NewGameFont.STYLE_LARGE, NewGameFont.COLOR_RED);
		}
		_txtGo.y = 16;
		FlxSpriteUtil.screenCenter(_txtGo, true, false);
		add(_txtGo);
		
		var _txtScore:NewGameFont = new NewGameFont(0, 0, "Score " +  StringTools.lpad("", ".", 30 - ("Score ".length + Std.string(Reg.score).length))  + " " + Reg.score, NewGameFont.STYLE_MED, NewGameFont.COLOR_YELLOW);// GameFont.STYLE_SM_WHITE, FlxBitmapFont.ALIGN_CENTER); // (0, 64, FlxG.width, "Score " +  StringTools.lpad("",".",40 - ("Score ".length + Std.string(Reg.score).length))  + " " + Reg.score);
		_txtScore.y = _txtGo.y + _txtGo.height + 16;
		FlxSpriteUtil.screenCenter(_txtScore, true, false);
		add(_txtScore);
		
		var _txtLeft:NewGameFont;
		var _txtBonus:NewGameFont;
		var _bonusScore:Int;
		
		switch (Reg.mode)
		{

			case  Reg.MODE_HUNGER:
				
				_txtLeft = new NewGameFont(0,0,"Time Left " + StringTools.lpad("", ".", 30 - ("Time ".length + FlxStringUtil.formatTime((PlayState.GAMETIME-Reg.gameTime), true).length)) +  " " + FlxStringUtil.formatTime((PlayState.GAMETIME-Reg.gameTime), true), NewGameFont.STYLE_MED, NewGameFont.COLOR_YELLOW);
				_bonusScore = Std.int((PlayState.GAMETIME-Reg.gameTime) * 25);
			case Reg.MODE_ENDLESS:
				_txtLeft = new NewGameFont(0,0,"Time " + StringTools.lpad("", ".", 30 - ("Time ".length + FlxStringUtil.formatTime(Reg.gameTime, true).length)) +  " " + FlxStringUtil.formatTime(Reg.gameTime, true), NewGameFont.STYLE_MED, NewGameFont.COLOR_YELLOW);
				_bonusScore = Std.int(Reg.gameTime * 10);
			default: 
				_txtLeft = new NewGameFont(0,0,"Living " + StringTools.lpad("", ".", 30 - ("Living ".length + Std.string(Reg.leftAlive).length)) +  " " + Reg.leftAlive, NewGameFont.STYLE_MED, NewGameFont.COLOR_YELLOW);
				_bonusScore = Reg.leftAlive * 100;
		}
		
		_txtLeft.y = _txtScore.y + _txtScore.height + 4;
		
		FlxSpriteUtil.screenCenter(_txtLeft, true, false);
		
		add(_txtLeft);
		
		
		_txtBonus = new NewGameFont(0,0,"Bonus " + StringTools.lpad("", ".", 30 - ("Bonus ".length + Std.string(_bonusScore).length)) +  " " + Std.string(_bonusScore), NewGameFont.STYLE_MED, NewGameFont.COLOR_YELLOW);
		
		//new FlxText(0, 80, FlxG.width, "Bonus " + StringTools.lpad("", ".", 40 - ("Bonus ".length + Std.string(_bonusScore).length)) +  " " + Std.string(_bonusScore));
		
		//_txtBonus.alignment = "center";
		_txtBonus.y = _txtLeft.y + _txtLeft.height + 4;
		FlxSpriteUtil.screenCenter(_txtBonus, true, false);
		add(_txtBonus);
		
		var totalScore:Int = _bonusScore + Reg.score;
		
		var _txtTotal:NewGameFont = new NewGameFont(0,0,"Total " + StringTools.lpad("", ".", 30 - ("Total ".length + Std.string(totalScore).length)) +  " " + Std.string(totalScore), NewGameFont.STYLE_MED, NewGameFont.COLOR_YELLOW);
		//new FlxText(0, 88, FlxG.width, "Total " + StringTools.lpad("",".",40 - ("Total ".length + Std.string(totalScore).length)) +  " " + Std.string(totalScore));
		//_txtTotal.alignment = "center";
		_txtTotal.y = _txtBonus.y + _txtBonus.height + 4;
		FlxSpriteUtil.screenCenter(_txtTotal, true, false);
		add(_txtTotal);
		
		
		var _btnContinue = new GameButton(0, 0, "Level Select", goContinue,GameButton.STYLE_SMALL, 110);
		
		_btnContinue.y = FlxG.height - _btnContinue.height - 16;
		_btnContinue.x = (FlxG.width / 2) + 32;
		
		add(_btnContinue);
		
		
		var _btnRetry = new GameButton(0, 0, "Replay", goRetry, GameButton.STYLE_LARGE, 0, true);
		_btnRetry.y = FlxG.height - _btnRetry.height - _btnContinue.height - 32;
		FlxSpriteUtil.screenCenter(_btnRetry, true, false);
		add(_btnRetry);
		
		var _btnMainMenu = new GameButton(0, 0, "Main Menu", goMainMenu,GameButton.STYLE_SMALL,110);
		_btnMainMenu .y = _btnContinue.y;
		_btnMainMenu .x = (FlxG.width / 2) - _btnMainMenu.width - 32;
		
		add(_btnMainMenu);
		
		
		if (_won || Reg.mode != Reg.MODE_NORMAL)
		{
			
			if (Reg.levels[Reg.level].bestScores[Reg.mode] < totalScore)
			{
				Reg.levels[Reg.level].bestScores[Reg.mode] = totalScore;
				Reg.saveScores();
				// put a 'hi score' thing?
				_hiScore = new NewGameFont(0,0,"HIGH SCORE!",NewGameFont.COLOR_BLUE,NewGameFont.STYLE_TINY);
				_hiScore.x = _txtTotal.x + _txtTotal.width - _hiScore.width;
				_hiScore.y = _txtTotal.y + _txtTotal.height +8;
				add(_hiScore);
				var hiTwn:FlxTween = FlxTween.singleVar(_hiScore, "alpha", .6, Reg.FADE_DUR, { type:FlxTween.PINGPONG, ease:FlxEase.circInOut } );
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
	
	private function goRetry():Void
	{
		if (!_loaded || _unloading)
			return;
		_unloading = true;
		FlxG.camera.fade(FlxColor.BLACK, .2, false, doneRetry);
	}
	
	private function doneRetry():Void 
	{
		FlxG.switchState(new PlayState());
	}
	
}