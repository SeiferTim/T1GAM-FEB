package ;

import flixel.addons.text.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

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
		
		var _txtLeft:FlxText = new FlxText(0, 72, FlxG.width, "Living " + StringTools.lpad("",".",40 - ("Living ".length + Std.string(Reg.leftAlive).length)) +  " " + Reg.leftAlive);
		_txtLeft.alignment = "center";
		add(_txtLeft);
		
		var _txtBonus:FlxText = new FlxText(0, 80, FlxG.width, "Bonus " + StringTools.lpad("",".",40 - ("Bonus ".length + Std.string(Reg.leftAlive * 100).length)) +  " " + Std.string(Reg.leftAlive * 100));
		_txtBonus.alignment = "center";
		add(_txtBonus);
		
		
		var _txtTotal:FlxText = new FlxText(0, 88, FlxG.width, "Total " + StringTools.lpad("",".",40 - ("Total ".length + Std.string((Reg.leftAlive * 100) + Reg.score).length)) +  " " + Std.string((Reg.leftAlive * 100) + Reg.score));
		_txtTotal.alignment = "center";
		add(_txtTotal);
		
		
		var _btnPlayAgain = new FlxButton(0, 0, "Play Again", goPlayAgain);
		_btnPlayAgain.y = FlxG.height - _btnPlayAgain.height - 16;
		FlxSpriteUtil.screenCenter(_btnPlayAgain);
		
		add(_btnPlayAgain);
		
		FlxG.camera.fade(FlxColor.BLACK, .2, true, doneFadeIn);
		
		super.create();
	}
	
	private function doneFadeIn():Void
	{
		_loaded = true;
	}
	
	private function goPlayAgain():Void 
	{
		if (!_loaded || _unloading)
			return;
		_unloading = true;
		FlxG.camera.fade(FlxColor.BLACK, .2, false, doneFadeOut);
	}
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new PlayState());
	}
	
}