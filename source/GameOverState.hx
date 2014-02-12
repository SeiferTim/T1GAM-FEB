package ;

import flixel.addons.text.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
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
		
		_won = Reg.gameTime <= 0 && Reg.leftAlive > 0;
		
		var _txtGo = new FlxText(0, 16, 200, "Game Over", 8);
		
		_txtGo.alignment = "center";
		FlxSpriteUtil.screenCenter(_txtGo, true, false);
		
		add(_txtGo);
		
		var _txtScore:FlxText = new FlxText(0, 64, FlxG.width, "Score " +  StringTools.lpad("",".",40 - ("Score ".length + Std.string(Reg.score).length))  + " " + Reg.score);
		_txtScore.alignment = "center";
		add(_txtScore);
		
		var _txtLeft:FlxText;
		
		if (Reg.mode == Reg.MODE_NORMAL)
		{
			_txtLeft = new FlxText(0, 72, FlxG.width, "Living " + StringTools.lpad("",".",40 - ("Living ".length + Std.string(Reg.leftAlive).length)) +  " " + Reg.leftAlive);
		}
		else //if (Reg.mode == Reg.MODE_ENDLESS)
		{
			_txtLeft = new FlxText(0, 72, FlxG.width, "Time " + StringTools.lpad("",".",40 - ("Time ".length + FlxStringUtil.formatTime(Reg.gameTime,true).length)) +  " " + FlxStringUtil.formatTime(Reg.gameTime,true));
		}
		
		_txtLeft.alignment = "center";
		add(_txtLeft);
		
		var _txtBonus:FlxText;
		var _bonusScore:Int;
		
		if (Reg.mode == Reg.MODE_NORMAL)
		{
			_bonusScore = Reg.leftAlive * 100;
			
			
		}
		else //if (Reg.mode == Reg.MODE_ENDLESS)
		{
			_bonusScore = Std.int(Reg.gameTime * 10);
		}
		
		_txtBonus = new FlxText(0, 80, FlxG.width, "Bonus " + StringTools.lpad("", ".", 40 - ("Bonus ".length + Std.string(_bonusScore).length)) +  " " + Std.string(_bonusScore));
		
		_txtBonus.alignment = "center";
		add(_txtBonus);
		
		
		var _txtTotal:FlxText = new FlxText(0, 88, FlxG.width, "Total " + StringTools.lpad("",".",40 - ("Total ".length + Std.string((_bonusScore) + Reg.score).length)) +  " " + Std.string((_bonusScore) + Reg.score));
		_txtTotal.alignment = "center";
		add(_txtTotal);
		
		
		var _btnPlayAgain = new FlxButton(0, 0, "Play Normal", goPlayAgain);
		_btnPlayAgain.y = FlxG.height - _btnPlayAgain.height - 16;
		_btnPlayAgain.x = (FlxG.width / 2) - _btnPlayAgain.width - 16;
		
		add(_btnPlayAgain);
		
		var _btnEndless = new FlxButton(0, 0, "Play Endless", goEndless);
		_btnEndless.y = _btnPlayAgain.y;
		_btnEndless.x = (FlxG.width / 2) + 16;
		
		add(_btnEndless	);
		
		FlxG.camera.fade(FlxColor.BLACK, .2, true, doneFadeIn);
		
		super.create();
	}
	
	private function doneFadeIn():Void
	{
		_loaded = true;
	}
	
	
	private function goEndless():Void
	{
		if (!_loaded || _unloading)
			return;
		Reg.mode = Reg.MODE_ENDLESS;
		_unloading = true;
		FlxG.camera.fade(FlxColor.BLACK, .2, false, doneFadeOut);
	}
	
	private function goPlayAgain():Void 
	{
		if (!_loaded || _unloading)
			return;
		Reg.mode = Reg.MODE_NORMAL;
		_unloading = true;
		FlxG.camera.fade(FlxColor.BLACK, .2, false, doneFadeOut);
	}
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new PlayState());
	}
	
}